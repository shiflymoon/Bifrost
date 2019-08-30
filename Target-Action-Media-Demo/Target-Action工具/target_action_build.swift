//
//  target_action_build.swift
//  TestSwiftControl
//
//  Created by 史贵岭 on 2019/8/16.
//  Copyright © 2019年 史贵岭. All rights reserved.
//

import Foundation

/***
 * 执行shell命令，返回执行结果和输出结果
 * demo shell("grep","-n","class ViewController: UIViewController","./ViewController.swift").1
 * 支持扩展表达式：shell("grep","-n","-E","class\\s*[a-zA-Z]+:\\s*[a-zA-Z]+\\s*{","./ViewController.swift").1
 */
@discardableResult func shell(_ args: String...) -> (Int32, String) {
    let process = Process()
    process.launchPath = "/usr/bin/env"
    process.arguments = args
    
    let pipe = Pipe()
    process.standardOutput = pipe
    
    process.launch()
    process.waitUntilExit()
    
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output: String = String(data: data, encoding: .utf8)!
    
    return (process.terminationStatus, output)
}

func printHowToUse() {
    print("Usage:")
    print("target_action_build -m ModuleName -i interfaceFilePath -e entityFilePath -scpath ScriptPath")
    print("Example: target_action_build -m Sale -i GoodService.h -e GoodsModel.h -scpath ./Script")
    print("-m 代表模块名字，必选参数")
    print("-i 代表接口.h文件路径，可选参数和-e必须存在一个")
    print("-e 代表实体定义.h文件路径，可选参数和-i必须存在一个")
    print("-scpath Script文件夹所在路径，可选参数")
}

func checkPartCommondLine() -> (String,String?,String?)? { //(m,i,e)
    var mValue: String = ""
    var iValue: String?
    var eValue: String?
    
    let args = CommandLine.arguments
    let count = Int(CommandLine.argc - 1)
    for i in stride(from: 1, to: count, by: 2) {
        if args[i] == "-m" {
            mValue = args[i+1]
        }
        if(args[i] == "-i") {
            iValue = args[i+1]
        }
        if(args[i] == "-e"){
            eValue = args[i+1]
        }
    }
    
    guard mValue.count > 0 else {
        print("ModuleName must exist ,please check -m params")
        return nil
    }
    
    if  iValue == nil && eValue == nil {
        print("-i or -e must exist One")
        return nil
    }
    
    if let iiValue = iValue , !FileManager.default.fileExists(atPath: iiValue) {
        print( "\(iiValue) file not exit,please check -i params")
        return nil
    }
    
    if let eeValue = eValue ,!FileManager.default.fileExists(atPath: eeValue) {
        print( "\(eeValue) file not exit,please check -e params")
        return nil 
    }
    
    return (mValue,iValue,eValue)
    
}
func checkFullCommondLine() -> (String,String,String,String)? {
    guard CommandLine.argc == 9 else {return nil}
  
    let args = CommandLine.arguments
    
    var mValue = ""
    var iValue = ""
    var scValue = ""
    var eValue = ""
    let count = Int(CommandLine.argc - 1)
    for i in stride(from: 1, to: count, by: 2) {
        if args[i] == "-m" {
            mValue = args[i+1]
        }
        if(args[i] == "-i") {
            iValue = args[i+1]
        }
        if(args[i] == "-scpath"){
            scValue = args[i+1]
        }
        if(args[i] == "-e"){
            eValue = args[i+1]
        }
    }
    
    if mValue.count < 1 {
        print("ModuleName must exist ,please check -m params")
        return nil
    }
    
    if !FileManager.default.fileExists(atPath: iValue) {
        print( "\(iValue) file not exit,please check -i params")
        return nil
    }
    
    if !FileManager.default.fileExists(atPath: eValue) {
        print( "\(eValue) file not exit,please check -e params")
        return nil
    }
    
    var moduleFile = ""
    var moduleCategoryFile = ""
    var rScValue = scValue
   
   
    if scValue.hasSuffix("/") {
        moduleFile = scValue + Constants.moduleExc
        moduleCategoryFile = scValue + Constants.moduleCategoryExc
    }else {
        moduleFile =  scValue + "/" + Constants.moduleExc
        moduleCategoryFile = scValue + "/" + Constants.moduleCategoryExc
        rScValue = scValue + "/"
    }

    if !FileManager.default.fileExists(atPath: moduleFile) {
        print(Constants.moduleExc+" file not exit,please check -scpath params")
        return nil
    }
    //chmod moduleFile
    shell("chmod","777",moduleFile)
    
    if !FileManager.default.fileExists(atPath: moduleCategoryFile) {
        print(Constants.moduleCategoryExc+" file not exit,please check -scpath params")
        return nil
    }
    //chmod moduleCategoryFile
    shell("chmod","777",moduleCategoryFile)
    
   
    return (mValue,iValue,eValue,rScValue);
    
}

func find_module_category_h_m_path(path: String,module: String) -> (String,String)? {
    let cHNmme = "\(Constants.moduleMediator)+\(module)Module.h"
    let cMName = "\(Constants.moduleMediator)+\(module)Module.m"
    
    var hResult = shell("find",path,"-name",cHNmme).1
    
    hResult.remove(pattern: "\r")
    hResult.remove(pattern: "\n")
  
    if hResult.count <= 0 {
        return nil
    }
    
    var mResult = shell("find",path,"-name",cMName).1
    mResult.remove(pattern: "\r")
    mResult.remove(pattern: "\n")
    if mResult.count <= 0 {
        return nil
    }
    
    return (hResult,mResult)
}

func find_module_target_action_h_m_path(path: String,module: String) -> (String,String)? {
    let cHNmme = "Target_\(module)Module.h"
    let cMName = "Target_\(module)Module.m"
    
    var hResult = shell("find",path,"-name",cHNmme).1
    hResult.remove(pattern: "\r")
    hResult.remove(pattern: "\n")
    if hResult.count <= 0 {
        return nil
    }
    
    var mResult = shell("find",path,"-name",cMName).1
    mResult.remove(pattern: "\r")
    mResult.remove(pattern: "\n")
    if mResult.count <= 0 {
        return nil
    }
    
    return (hResult,mResult)
}

func buildPartCommondPRJ() {
    guard let pCommond = checkPartCommondLine() else {
        printHowToUse()
        return
    }
    
    let moduleName = pCommond.0
    
    let outPut = makeOutPutNoProj(module: moduleName)
    
    //由于没有调用脚本产生TargetAction工程和Category工程，所以需要手动创建对应文件
    let categoryHFile = "\(outPut)/\(moduleName)\(Constants.moduleSuffix)Category.h"
    let categroryMFile = "\(outPut)/\(moduleName)\(Constants.moduleSuffix)Category.m"
    createFiles(files: [categoryHFile,categroryMFile]) 
    
    if let interfaceFilePath = pCommond.1 {
        //构造动态产生代码
        let moduleCategory = ModuleCategory(sourceStr: String(file: interfaceFilePath), moduleName: moduleName)
        let moduleTargetAction = ModuleTargetAction(methodInfo: moduleCategory.tartgetActionMethodInfo, importStr: moduleCategory.moduleHeadImportDeclare, mName: moduleName) 
        
        //申明文件
        let targetActionHFile = "\(outPut)/Target_\(moduleName)\(Constants.moduleSuffix).h"
        let targetActionMFile = "\(outPut)/Target_\(moduleName)\(Constants.moduleSuffix).m"
        
        createFiles(files: [targetActionHFile,targetActionMFile]) 
        
        //写入内容-Category.h
        var categoryHStr = String(file: categoryHFile)
        if let categoryDeclare = moduleCategory.moduleInterfaceDeclare {//.h
          let _ = categoryHStr.insert(pattern: Constants.module_nReg, content: categoryDeclare, iType: .After)
        }
        
        categoryHStr.write2File(file: categoryHFile)
       
        //写入内容-Category.m
        var categoryMStr = String(file: categroryMFile)
        var cMContent = ""
        if let categoryImportDefien = moduleCategory.moduleMFileImportDefine {//.m
            let forOneContent = categoryImportDefien + "\n" + moduleCategory.moduleTargetDefine
            cMContent += forOneContent
        }
        if let categoryDefine = moduleCategory.moduleInterfaceDefine {//.m
            cMContent += categoryDefine
        }
        let _ = categoryMStr.insert(pattern: Constants.module_nReg, content: cMContent, iType: .After)
        
        categoryMStr.write2File(file: categroryMFile)
       
        //替换targetaciton.h文件
        var targetActionHStr = String(file: targetActionHFile)
        if let targetActionDeclare = moduleTargetAction.moduleInterfaceDeclare {//.h
           let _ = targetActionHStr.insert(pattern: Constants.module_nReg, content: targetActionDeclare, iType: .After)
        }
        targetActionHStr.write2File(file: targetActionHFile)
      
        //替换targetaciton.m文件
        var targetActionMStr = String(file: targetActionMFile)
        var taMContent = ""
        if let targetActionImport = moduleTargetAction.moduleHeadImportDeclare {//.m
            taMContent += targetActionImport
        }
        if let targetActionImp = moduleTargetAction.moduleInterfaceDefine {
            taMContent += targetActionImp
        }
        let _ = targetActionMStr.insert(pattern: Constants.module_nReg, content: taMContent, iType: .After)
        
        targetActionMStr.write2File(file: targetActionMFile)
        
    }
    
    if let entityFilePath = pCommond.2 {
        
        let entityFileC = String(file: entityFilePath)
        guard let entities = entityFileC.protocolEntites() else {
            return
        }
        let moduleEn = ModuleEntity(nameSource: entities, mName: moduleName)
        var categoryHStr = String(file: categoryHFile)
        var categoryMStr = String(file: categroryMFile)
        
        let _ = categoryHStr.insert(pattern: Constants.module_nReg, content: moduleEn.moduleDeclare, iType: .After)
        let _ = categoryMStr.insert(pattern: Constants.module_nReg, content: moduleEn.moduleDefine, iType: .After)
      
        categoryHStr.write2File(file: categoryHFile)
        categoryMStr.write2File(file: categroryMFile)
    }
    
    shell("open",".")
}


func buildTargetActionPRJ() {

    guard let commond = checkFullCommondLine() else {
        printHowToUse()
        return
    }
    
    let moduleName = commond.0
    let interfaceFilePath = commond.1
    let entityFilePath = commond.2
    let scriptFilePath = commond.3
    
    //根据模版产生Module和对应的ModuleCategory文件
    let outPath = makeModuleAndCategory(module: moduleName , scPath: scriptFilePath)
    
    
    let entityFileC = String(file: entityFilePath)
    guard let entities = entityFileC.protocolEntites() else {
        return
    }
    
    let moduleCategory = ModuleCategory(sourceStr: String(file: interfaceFilePath), moduleName: moduleName)
    let moduleTargetAction = ModuleTargetAction(methodInfo: moduleCategory.tartgetActionMethodInfo, importStr: moduleCategory.moduleHeadImportDeclare, mName: moduleName)
    let moduleEn = ModuleEntity(nameSource: entities, mName: moduleName)
    
    guard let categoryPathTruple =  find_module_category_h_m_path(path: outPath, module: moduleName) else {
        print("\(Constants.moduleMediator)+\(moduleName)Module.h/m not find ")
        return
    }
    guard let targetActionPathTruple = find_module_target_action_h_m_path(path: outPath, module: moduleName) else {
        print("Target_\(moduleName)Module.h/m not find")
        return
    }
    
    //替换category.h文件
    var categoryInterfaceHStr = String(file: categoryPathTruple.0) 
    //添加实体定义到.h文件
    let re = categoryInterfaceHStr.insert(pattern: Constants.moduleNS_ASSUME_NONNULL_BEGINReg, content: moduleEn.moduleDeclare, iType: .After)
    if !re {
       let _ = categoryInterfaceHStr.insert(pattern: Constants.moduleCaInterfaceReg, content: moduleEn.moduleDeclare, iType: .InFront) 
    }

    if let categoryDeclare = moduleCategory.moduleInterfaceDeclare {//.h
      let _ = categoryInterfaceHStr.insert(pattern:Constants.moduleCaInterfaceReg , content: categoryDeclare, iType: .After)
    }
    
    categoryInterfaceHStr.write2File(file: categoryPathTruple.0)
  
    //替换category.m文件
    var categoryInterfaceMStr = String(file: categoryPathTruple.1)
    var beforeC = moduleEn.moduleDefine
    if let categoryImportDefien = moduleCategory.moduleMFileImportDefine {//.m
        let forOneContent = categoryImportDefien + "\n" + moduleCategory.moduleTargetDefine
        beforeC += forOneContent
    }
    let _ = categoryInterfaceMStr.insert(pattern: Constants.moduleCaImplementationReg, content: beforeC, iType: .InFront)
  
    if let categoryDefine = moduleCategory.moduleInterfaceDefine {//.m
        let _ = categoryInterfaceMStr.insert(pattern: Constants.moduleCaImplementationReg, content: categoryDefine, iType: .After)
    }
   
    categoryInterfaceMStr.write2File(file: categoryPathTruple.1)
   
    
    //替换targetaciton.h文件
    var targetActionHStr = String(file: targetActionPathTruple.0)
    if let targetActionDeclare = moduleTargetAction.moduleInterfaceDeclare {//.h
      let _ = targetActionHStr.insert(pattern: Constants.moduleTaInterfaceReg, content: targetActionDeclare, iType: .After)
    }
    
    targetActionHStr.write2File(file: targetActionPathTruple.0)
    
    //替换targetacion.m文件
    var targetActionMStr = String(file: targetActionPathTruple.1)
    if let targetActionImport = moduleTargetAction.moduleHeadImportDeclare {//.m
       let _ = targetActionMStr.insert(pattern: Constants.moduleTaImpReg, content: targetActionImport, iType: .InFront)
    }
    if let targetActionImp = moduleTargetAction.moduleInterfaceDefine {
        let _ = targetActionMStr.insert(pattern: Constants.moduleTaImpReg, content: targetActionImp, iType: .After)
    }
    
    targetActionMStr.write2File(file: targetActionPathTruple.1)
    
}

func run_target_action_commond()  {
    let commondCount = CommandLine.argc
    if commondCount == 9 {
       buildTargetActionPRJ() 
    }else {
        buildPartCommondPRJ()
    }
}

struct Constants {
    static let moduleExc = "createModule.sh"
    static let moduleCategoryExc = "createModuleCategory.sh"
    static let moduleDir = "TemplateModule"
    static let moduleCategoryDir = "TemplateModuleCategory"
    static let moduleCategorySuffix = "ModuleCategory"
    static let moduleOutSuffix = "ModuleOut"
    static let moduleSuffix = "Module"
    static let TargetActionMethodPrefix = "Action_"
    static let moduleConstantsDeclarePrefix = "UIKIT_EXTERN NSString *const "
    static let moduleConstantsDefinePrefix = "NSString *const "
    static let moduleNS_ASSUME_NONNULL_BEGINReg = "NS_ASSUME_NONNULL_BEGIN\\s"
    static let moduleCaInterfaceReg = "@interface\\s*[a-zA-Z0-9_]+\\s*\\([a-zA-Z0-9_]+\\)\\s"
    static let moduleCaImplementationReg = "@implementation\\s*[a-zA-Z0-9_]+\\s*\\([a-zA-Z0-9_]+\\)\\s"
    static let moduleTaInterfaceReg = "@interface\\s*[a-zA-Z0-9_]+\\s*:\\s*[a-zA-Z0-9_]+\\s"
    static let moduleTaImpReg = "@implementation\\s*[a-zA-Z0-9_]+\\s"
    static let module_nReg  = "\\s"
    static let moduleMediator = "CTMediator"
}

func makeModuleAndCategory(module: String ,scPath: String) -> String  {
    let outPut = module+Constants.moduleOutSuffix
 
    try? FileManager.default.removeItem(atPath: outPut)
    try? FileManager.default.createDirectory(atPath: outPut, withIntermediateDirectories: true, attributes: nil)
    
    //复制到当前目录，由于通过/usr/bin/env调用shell，所以不支持cd命令
    shell("cp","-r","-f",scPath+Constants.moduleDir,".")
    shell("cp","-r","-f",scPath+Constants.moduleCategoryDir,".")
    shell("cp","-f",scPath+Constants.moduleExc,".")
    shell("cp","-f",scPath+Constants.moduleCategoryExc,".")
    
    //执行脚本，产生Module和ModuleCategory,mv Module和ModuleCategory到目标路径
    shell("./"+Constants.moduleExc,module)
    shell("mv",module,outPut)
    shell("./"+Constants.moduleCategoryExc,module)
    shell("mv",module+Constants.moduleCategorySuffix,outPut)
    
    //删除复制过来的文件
    shell("rm","-f","./"+Constants.moduleExc)
    shell("rm","-f","./"+Constants.moduleCategoryExc)
    shell("rm","-rf","./"+Constants.moduleDir)
    shell("rm","-rf","./"+Constants.moduleCategoryDir)
    
    return outPut
    
}

func makeOutPutNoProj(module: String) -> String {
    let outPut = module+Constants.moduleOutSuffix+"NoProj"
    
    try? FileManager.default.removeItem(atPath: outPut)
    try? FileManager.default.createDirectory(atPath: outPut, withIntermediateDirectories: true, attributes: nil)
    return outPut
}

func createFiles(files: [String])  {
    let data = "\n\n".data(using: .utf8)
    for file in files {
         FileManager.default.createFile(atPath: file, contents: data, attributes: nil)
    }
}

enum ModuleMethodRTType {
    case ID,OBJ,NSINTEGER,NSUINTEGER,CGFLOAT,BOOL,VOID,
         LONG,INT,DOUBLE,FLOAT,UNSIGNEDLONG,UNSIGNEDINT,CHAR,
         UNSIGNEDCHAR ,SHOR,UNSIGNEDSHORT,LONGLONG,UNSIGNEDLONGLONG
    func introduced() -> String {
        switch self {
        case .ID:
            return ""
        case .OBJ:
            return ""
        case .VOID:
            return ""
        case .NSINTEGER:
            return "integerValue"
        case .NSUINTEGER:
            return "unsignedIntegerValue"
        case .CGFLOAT:
            return "floatValue"
        case .BOOL:
            return "boolValue"
        case .LONG:
            return "longValue"
        case .INT:
            return "intValue"
        case .DOUBLE:
            return "doubleValue"
        case .FLOAT:
            return "floatValue"
        case .UNSIGNEDLONG:
            return "unsignedLongValue"
        case .UNSIGNEDINT:
            return "unsignedIntValue"
        case .CHAR:
            return "charValue"
        case .UNSIGNEDCHAR:
            return "unsignedCharValue"
        case .SHOR:
            return "shortValue"
        case .UNSIGNEDSHORT:
            return "unsignedShortValue"
        case .LONGLONG:
            return "longLongValue"
        case .UNSIGNEDLONGLONG:
            return "unsignedLongLongValue"
        }
    }
    
    static func fromSlang(item: String) -> ModuleMethodRTType {
        if let _ = item.range(pattern: "\\*") {//*号是正则关键字，需要转义
            return .OBJ
        }
        if item == "void" {//必须在 item.range(pattern: "id")前
            return .VOID
        }
        if let _ = item.range(pattern: "id") {
            return .ID
        }
        if item ==  "NSInteger" {
            return .NSINTEGER
        }
        if item ==  "NSUInteger" {
            return .NSUINTEGER
        }
        if item == "CGFloat" {
            return .CGFLOAT
        }
        if item == "BOOL" {
            return .BOOL
        }
        if item == "long" {
            return .LONG
        }
        if item == "int" {
            return .INT
        }
        if item == "double" {
            return .DOUBLE
        }
        if item == "float" {
            return .FLOAT
        }
        if item == "unsignedlong" {
            return .UNSIGNEDLONG
        }
        if item == "unsignedint" {
            return .UNSIGNEDINT
        }
        if item == "char" {
            return .CHAR
        }
        if item == "unsignedchar" {
            return .UNSIGNEDCHAR
        }
        if item == "short" {
            return .SHOR
        }
        if item == "unsignedshort" {
            return .UNSIGNEDSHORT
        }
        if item == "longlong" {
            return .LONGLONG
        }
        if item == "unsignedlonglong" {
            return .UNSIGNEDLONGLONG
        }
        return .OBJ
    }
}

func kParamName(moduleName: String, param: String) -> String {
    return   "k" + moduleName.firstCharUpercased() + "Param" + param.firstCharUpercased()
}

func kEntityName(moduleName: String,name: String) -> String {
     return   "k" + moduleName.firstCharUpercased() + "Entity" + name.firstCharUpercased()
}

class TagetActionMethodInfo {
    var methodType: String //+(NSDictionary *)
    var paramTypeName: [(String,String,String)]? //(NSString*,sex,"NSString * ") 去空格,参数名称，原始串
    var selector: String //allGoodsList:
    public init(type: String , param: [(String,String,String)]? , SEL: String){
        methodType = type
        paramTypeName = param
        selector = SEL
    }
}

class ModuleEntity {
    static let EntityLineMaxNum = 2 //shell 一次不能插入太多，单个实体内，默认EntityLineMaxNum个属性单独写一次文件
    var moduleDeclare: String
    var moduleDefine: String
    
    var moduleEntityNameSource: [(String,String)]?
    var moduleName: String
    
    public init(nameSource: [(String,String)]? , mName: String){
        moduleEntityNameSource = nameSource
        moduleName = mName
        
        moduleDeclare = ""
        moduleDefine = ""
        
        makeEntityDeclareDefine()
    }
    
    func makeEntityDeclareDefine()  {
        guard let nameSource = moduleEntityNameSource else {
            return
        }
        
        var tDeclare = "\n"
        var tDefine = "\n"
        for oneEntityStr in nameSource {
            let name = oneEntityStr.0
            var onePropertyDeclare = ""
            var onePropertyDefine = ""
            guard let nameSouceArray = oneEntityStr.1.propertyNameType() else {
                continue
            }
            
            let pragmaStr = "#pragma mark - \(name) Entiry Dic key\n"
            
            onePropertyDeclare +=  pragmaStr
            onePropertyDefine += pragmaStr
            
            for typePName in nameSouceArray {
                let pType = typePName.0
                let pName = typePName.1
                onePropertyDeclare += buildOnePropertyComment(property: pName, type: pType, name: name)
                onePropertyDeclare += buildOnePropetyDeclare(property: pName)
                onePropertyDefine += buildOnePropertyDefine(property: pName)
                onePropertyDeclare += "\n"
                onePropertyDefine += "\n"
                
            }
            
            onePropertyDefine += "\n"
            onePropertyDeclare += "\n"
            
            tDefine += onePropertyDefine
            tDeclare += onePropertyDeclare
        }//for nameSource
        
        moduleDefine = tDefine
        moduleDeclare = tDeclare
    }
    
    func buildOnePropertyComment(property: String,type: String,name: String) -> String {
        let comment = "\(name)实体的\(property)属性，类型为：\(type)"
        let placeStr = "/**\n* \(comment)\n*/\n"
        return placeStr
    }
    
    func buildOnePropetyDeclare(property: String) -> String {
        let prefix = Constants.moduleConstantsDeclarePrefix
        return prefix + kEntityName(moduleName: moduleName, name: property) + " ;"
    }
    
    func buildOnePropertyDefine(property: String) -> String {
        let prefix = Constants.moduleConstantsDefinePrefix
        let mid =  kEntityName(moduleName: moduleName, name: property)+" = @\""+property.lowercased()+"\""
        let full = prefix + mid + ";"
        return full
    }
}

class ModuleTargetAction {
    var moduleHeadImportDeclare: String? //
    
    var moduleInterfaceDeclare: String?
    var moduleInterfaceDefine: String?
    
    var tartgetActionMethodInfo: [TagetActionMethodInfo]
    var moduleName: String
    
    public init(methodInfo: [TagetActionMethodInfo] ,importStr: String? ,mName: String){
        tartgetActionMethodInfo = methodInfo
        moduleName = mName
        moduleHeadImportDeclare = importStr
        
        makeInterfacAndDefine()
    }
    
    func makeInterfacAndDefine()  {
        
        if let iDeclareImp  = buildInterfacAndDefine() {
            moduleInterfaceDeclare = "\n"+iDeclareImp.0+"\n"
            moduleInterfaceDefine = "\n"+iDeclareImp.1+"\n"
        }
    }
    
    func buildInterfacAndDefine() -> (String,String)? {
        
        if tartgetActionMethodInfo.count <= 0 {
            return nil;
        }
        
        var interfaceDeclareArray = [String]()
        var interfaceDefineArray = [String]()
        
        for mInfo in tartgetActionMethodInfo {
            var oneDeclare = ""
            var oneDefine = ""
            var oneFunc = ""
            
            oneFunc += mInfo.methodType + mInfo.selector
            
            oneDeclare += oneFunc
            
            //根据返回类型类型构造默认返回值
            var returnStr = ""
            var mreType = mInfo.methodType
            mreType.remove(pattern: "\\(")//正则需要转义
            mreType.remove(pattern: "\\)")
            mreType.remove(pattern: "\\s")
            mreType.remove(pattern: "\\+")
            mreType.remove(pattern: "-")
            let mMMType = ModuleMethodRTType.fromSlang(item: mreType)
            
            if mMMType != .VOID && mMMType != .ID && mMMType != .OBJ {
                returnStr = "\n\treturn 0 ; "
            }else if mMMType == .ID ||  mMMType == .OBJ  {
                returnStr = "\n\treturn nil ;"
            }
            
            var paramsGet = "\n"
            
            //还原参数
            if let param = mInfo.paramTypeName  {
                oneDeclare += ":(NSDictionary *)params"
                for item in param {
                    
                    let pName = kParamName(moduleName: moduleName, param: item.1)
                    paramsGet += "\t"
                    let mType = ModuleMethodRTType.fromSlang(item: item.0)
    
                    var finalOneParamPrefix = ""
                    var finalOneParamSuffix = ""
                    var pType = ""
                    
                    if mType != .VOID && mType != .ID && mType != .OBJ { //不是对象
                        let rrtypeStr = mType.introduced()
                        if rrtypeStr.count > 0 {
                            finalOneParamPrefix += "["
                            finalOneParamSuffix += " \(rrtypeStr)]"
                        }
                        pType = item.0
                    }else if mType == .ID {
                        pType = "id"
                    }else if mType == .OBJ {
                        pType = "id"
                        if let sss = item.2.fucReNSObjType() {
                            pType = sss
                        }
                    }
                    
                    paramsGet  += pType + " \(item.1) = "
                    paramsGet += finalOneParamPrefix + "params[\(pName)]" + finalOneParamSuffix + ";\n"
                   
                }
            }
            
            oneDefine += oneDeclare
            oneDeclare += ";"
            oneDefine += " {"
            oneDefine += paramsGet + returnStr + "\n}"
            
            interfaceDeclareArray.append(oneDeclare)
            interfaceDefineArray.append(oneDefine)
        }
        
   
        let interfaceDefine = interfaceDeclareArray.joined(separator: "\n\n") 
        let interfaceImp = interfaceDefineArray.joined(separator: "\n\n") 
        
        return (interfaceDefine,interfaceImp)
    }
    
    
    
}
class ModuleCategory {
    var moduleName: String
    
    var moduleInterfaceWithParams: [String]? //带参数的函数
    var moduleInterfaceWithNoParams: [String]? //不带参数的函数
    
    var moduleHeadImportDeclare: String? //extern NSString * const kSaleModuleShoppingCartParamGoodId
    var moduleMFileImportDefine: String? //NSString * const kSaleModuleShoppingCartParamGoodId = @"GoodId"
    var moduleInterfaceDeclare: String?  //新的接口声明
    var moduleInterfaceDefine: String?   //新接口实现
    
    var moduleTargetDefine: String
    var moduleTarget: String
    
    var tartgetActionMethodInfo: [TagetActionMethodInfo]
    
    public init(sourceStr: String,moduleName: String){
        self.moduleName = moduleName
        self.moduleInterfaceWithParams = sourceStr.interfaceWithParams()
        self.moduleInterfaceWithNoParams = sourceStr.interfaceNoParams()
        
        //NSString * const SaleModuleTarget = @"SaleModule";
        let prefix = "NSString * const "
        self.moduleTarget = moduleName.firstCharUpercased()+Constants.moduleSuffix+"Target"
        let middle = self.moduleTarget+" = @\""
        let suffix = moduleName.firstCharUpercased()+Constants.moduleSuffix+"\"; \n\n"
        self.moduleTargetDefine = prefix+middle+suffix
        
        self.tartgetActionMethodInfo =  [TagetActionMethodInfo]()
    
        
        makeHeadImportAndDefine();
        makeInterfaceAndDefine();
    }
    
    
    func makeHeadImportAndDefine() {
       //提取有参数函数参数
        guard  let intFaceParas = self.moduleInterfaceWithParams  else { return }
        
        var paramsSet = Set<String>()
        for funcStr in intFaceParas {
            if let tmpArray = funcStr.interfaceFunctionNameTypeParamsName() {
               
                for paramTuple in tmpArray {
                    paramsSet.insert(paramTuple.2)
                }
            }
        }
       
       
        let paramsArray = Array<String>(paramsSet)
        
        if let importDeclare = uiKitExternDeclare(module: moduleName, params: paramsArray) {
           
            let strData = importDeclare.joined(separator: "\n")+"\n\n"
            self.moduleHeadImportDeclare = strData
        }
      
        if let mFileDefine = uiKitExternDefine(module: moduleName, params: paramsArray) {
            let definePragma = "#pragma mark - \(moduleName)\(Constants.moduleSuffix) Function Param key \n"
            let strData = definePragma + mFileDefine.joined(separator:  "\n")+"\n"
            self.moduleMFileImportDefine = strData
        }
    }
    
    
    func makeInterfaceAndDefine()  {
        
        var tInterfaceDeclare = ""
        var tInterfaceDefine = ""
        
        if let pmDeclareImp = buildInterfaceParamAndDefine() {
            tInterfaceDeclare += pmDeclareImp.0 
            tInterfaceDefine += pmDeclareImp.1 
        }
        
        if let pmNoDeclareImp = buildInterfaceNoParamAndDefine() {
            tInterfaceDeclare += "\n\n"+pmNoDeclareImp.0+"\n"
            tInterfaceDefine += "\n\n"+pmNoDeclareImp.1+"\n"
        }
        
        moduleInterfaceDeclare = tInterfaceDeclare
        moduleInterfaceDefine = tInterfaceDefine
}
    
    func buildInterfaceParamAndDefine() -> (String,String)? {
        guard  let intFaceParas = self.moduleInterfaceWithParams  else { return nil}
        
        var  funcArray = [String]()
        var  funcImpArray = [String]()
        for funcStr in intFaceParas {
            
            var oneFunc = ""
            var oneFuncImp = ""
            var targetActionMethod = Constants.TargetActionMethodPrefix
            var targetActionparamTypeName = [(String,String,String)]()
            var targetActionMethodType = ""
            
            //得到返回值
            guard let rtStr = funcStr.interfacePrefixValueType() else {continue}
            oneFunc += rtStr
            targetActionMethodType += rtStr
            guard let tmpArray = funcStr.interfaceFunctionNameTypeParamsName() else {continue}
            
            var paramDic = "\tNSMutableDictionary *params = [[NSMutableDictionary alloc] init] ;\n"
            for (index,pTruple) in tmpArray.enumerated() {
                if(index == 0){//第一个参数增加module前缀
                   oneFunc += moduleName.firstCharLowercased()+"_"
                }
            
                oneFunc += pTruple.0+":"+pTruple.1+pTruple.2+" "
                var paramType = pTruple.1
                paramType.remove(pattern: "\\(")//正则需要转义
                paramType.remove(pattern: "\\)")
                paramType.remove(pattern: "\\s")
                var paramValue = "\(pTruple.2) ;\n"
                let mType = ModuleMethodRTType.fromSlang(item: paramType)
              
                if mType != .VOID && mType != .ID && mType != .OBJ {
                    paramValue = "@(\(pTruple.2)) ;\n"
                }
                   
                paramDic += "\tparams["+kParamName(moduleName: moduleName, param: pTruple.2)+"] = " + paramValue
                
                if index != (tmpArray.count - 1) {
                    targetActionMethod +=  pTruple.0 + "_"
                }else {
                    targetActionMethod +=  pTruple.0
                }
                
                targetActionparamTypeName.append((paramType,pTruple.2,pTruple.1))
            }
            
            //oneFuncImp同接口使用相同部分
            oneFuncImp += oneFunc + "{ "+"\n"
            oneFuncImp += paramDic
            var returnType = funcStr.interfaceValueType()
            returnType?.remove(pattern: "\\s")
          
            guard  let rTypeStr = returnType else {continue}
            let rrtype = ModuleMethodRTType.fromSlang(item: rTypeStr)
            if rrtype != ModuleMethodRTType.VOID {
                oneFuncImp += "\n\treturn "
            }else {
                oneFuncImp += "\n\t"
            }
            let rrtypeStr = rrtype.introduced()
            var finalOneFuncImpPrefix = ""
            var finalOneFuncImpSuffix = ""
            if rrtypeStr.count > 0 {
                finalOneFuncImpPrefix += "["
                finalOneFuncImpSuffix += " \(rrtypeStr)]"
            }
            
            oneFuncImp += finalOneFuncImpPrefix + "[self performTarget:\(moduleTarget) action:@\"\(targetActionMethod):\" params:params shouldCacheTarget:NO]" + finalOneFuncImpSuffix
            oneFuncImp += ";\n}"
            oneFunc += ";"
            
            let oneTargetInfo = TagetActionMethodInfo(type: targetActionMethodType, param: targetActionparamTypeName, SEL: targetActionMethod)
            
            tartgetActionMethodInfo.append(oneTargetInfo)
            funcArray.append(oneFunc)
            funcImpArray.append(oneFuncImp)
            
        }
        
        guard funcArray.count > 0 , funcImpArray.count > 0 else { return nil }
        
        let interfacePragma = "\n#pragma mark - \(moduleName)\(Constants.moduleSuffix) Service\n\n" 
        let interfaceDefine = interfacePragma + funcArray.joined(separator: "\n\n") 
        let interfaceImp = interfacePragma + funcImpArray.joined(separator: "\n\n") 
        
        return (interfaceDefine,interfaceImp)
        
    }
    
    func buildInterfaceNoParamAndDefine() -> (String,String)? {
        guard  let intFaceParas = self.moduleInterfaceWithNoParams  else { return nil}
        
        var  funcArray = [String]()
        var  funcImpArray = [String]()
        for funcStr in intFaceParas {
            
            var oneFunc = ""
            var oneFuncImp = ""
           
            var targetActionMethodType = ""
            var targetActionMethod = Constants.TargetActionMethodPrefix
            
            //得到返回值
            guard let rtStr = funcStr.interfacePrefixValueType() else {continue}
            oneFunc += rtStr
            targetActionMethodType += rtStr
            
            guard let fName = funcStr.interfaceNoParamsFName() else {continue}
           
            targetActionMethod += fName
            oneFunc += fName
    
            //oneFuncImp同接口使用相同部分
            oneFuncImp += oneFunc + " { "+"\n"
         
            var returnType = funcStr.interfaceValueType()
            returnType?.remove(pattern: "\\s")
            
            guard  let rTypeStr = returnType else {continue}
            let rrtype = ModuleMethodRTType.fromSlang(item: rTypeStr)
            if rrtype != ModuleMethodRTType.VOID {
                oneFuncImp += "\n\treturn "
            }else {
                oneFuncImp += "\n\t"
            }
            let rrtypeStr = rrtype.introduced()
            var finalOneFuncImpPrefix = ""
            var finalOneFuncImpSuffix = ""
            if rrtypeStr.count > 0 {
                finalOneFuncImpPrefix += "["
                finalOneFuncImpSuffix += " \(rrtypeStr)]"
            }
            
            oneFuncImp += finalOneFuncImpPrefix + "[self performTarget:\(moduleTarget) action:@\"\(targetActionMethod)\" params:nil shouldCacheTarget:NO]" + finalOneFuncImpSuffix
            oneFuncImp += ";\n}"
            oneFunc += ";"
            
            let oneTargetInfo = TagetActionMethodInfo(type: targetActionMethodType, param: nil, SEL: targetActionMethod)
            
            tartgetActionMethodInfo.append(oneTargetInfo)
            funcArray.append(oneFunc)
            funcImpArray.append(oneFuncImp)
            
        }
        
        guard funcArray.count > 0 , funcImpArray.count > 0 else { return nil }
        
        let interfaceDefine = funcArray.joined(separator: "\n\n") 
        let interfaceImp = funcImpArray.joined(separator: "\n\n") 
        
        return (interfaceDefine,interfaceImp)
    }
 
    
    func importUIKit() -> String {
        return "#import <UIKit/UIKit.h>\n"
    }
    
    //产生UIKIT_EXTERN NSString *const定义
    func uiKitExternDeclare(module: String ,params: [String]) -> [String]? {
        guard module.count > 0 , params.count > 0 else{return nil}
        
        var result = [String]();
        
        result.append(importUIKit())
        
        let prefix = Constants.moduleConstantsDeclarePrefix
        
        for param in params {
            let mid =  kParamName(moduleName:module ,param: param)
            let full = prefix + mid + ";"
            result.append(full)
        }
        return  result
    }
    
    //产生 NSString *const定义
    func uiKitExternDefine(module: String ,params: [String]) -> [String]? {
        guard module.count > 0 , params.count > 0 else{return nil}
        
        var result = [String]();
        
        let prefix = Constants.moduleConstantsDefinePrefix
        
        for param in params {
           
            let mid =  kParamName(moduleName: moduleName, param: param) + " = @\""+param.lowercased()+"\""
            let full = prefix + mid + ";"
            result.append(full)
        }
        return  result
    }
}

extension String {
    
    enum InsertType {
        case InFront,After
    }
    
    public init(file: String) {
        if let data = FileManager.default.contents(atPath: file) {
            self = String(data:data, encoding: String.Encoding.utf8)!
        } else {
            self = ""
        }
    }
    
    func write2File(file: String)  {
        if !FileManager.default.fileExists(atPath: file) {
            FileManager.default.createFile(atPath: file, contents: nil, attributes: nil)
        }
       
        guard let fileHandle = FileHandle(forWritingAtPath: file) else {
            return
        }
        
        fileHandle.write(self.data(using: .utf8)!)
        fileHandle.synchronizeFile()
        fileHandle.closeFile()
    }
    
    mutating func insert(pattern: String,content: String,iType: InsertType) -> Bool{
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return false
        }
        let range = regex.rangeOfFirstMatch(in: self, options: [], range: NSMakeRange(0, self.count))
        if range.location == NSNotFound {
            print("\(pattern)")
            return false
        }
        let nsSelf = self as NSString 
        let prefix = nsSelf.substring(to: range.location)
        let match = nsSelf.substring(with: range)
        let suffix = nsSelf.substring(from: range.location+range.length)
        
        if iType == .After {
           self = prefix+match+content+suffix 
        }else if iType == .InFront {
           self = prefix+content+match+suffix
        }
        return true
    }
    
    mutating func remove(pattern:String) {
        while true {
            let range = self.range(pattern: pattern)
            if range != nil {
                self.removeSubrange(range!)
            } else {
                break;
            }
        }
    }
    
    /// range转换为NSRange
    func nsRange(from range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }
    
    
    /// NSRange转化为range
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
    
    func firstCharLowercased() -> String {
        let fLow = self.prefix(1).lowercased();
        let suffix = self.suffix(self.count-1);
        return  fLow+suffix
    }
    
    func firstCharUpercased() -> String {
        let fLow = self.prefix(1).uppercased();
        let suffix = self.suffix(self.count-1);
        return  fLow+suffix
    }
    
    func range(of:String,  offset: String.Index) -> Range<String.Index>? {
        let range = offset ..< self.endIndex
        return self.range(of: of, options: String.CompareOptions(rawValue: 0), range: range, locale: nil)
    }
    
    func range(pattern:String,  offset: String.Index) -> Range<String.Index>? {
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        if regex != nil {
            let offsetInt = self.distance(from: self.startIndex, to: offset)
            let range = regex!.rangeOfFirstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue:0), range: NSMakeRange(offsetInt, self.count - offsetInt))
            if range.location != NSNotFound {
                return self.index(self.startIndex, offsetBy: range.location)..<self.index(self.startIndex, offsetBy: range.location + range.length)
            }
        }
        return nil;
    }
    
    func range(pattern:String) -> Range<String.Index>? {
        return self.range(pattern: pattern, offset: self.startIndex)
    }
    
    func range2(from range: NSRange) -> Range<String.Index>? {
       /* if range.location != NSNotFound{
            return self.index(self.startIndex, offsetBy: range.location)..<self.index(self.startIndex, offsetBy: range.location + range.length)
        }
        return nil;*/
        guard  range.location != NSNotFound else {return nil}
        
        return self.index(self.startIndex, offsetBy: range.location)..<self.index(self.startIndex, offsetBy: range.location + range.length)
    }
    
    func range(regx pattern: String) -> [String]? {
        if let regx = try? NSRegularExpression.init(pattern: pattern, options: .dotMatchesLineSeparators){
            let checkResult = regx.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            var crArray = [String]();
            for cr in checkResult {
                let range = cr.range(at: 0)
                if range.location != NSNotFound{
                    let str = String(self[range2(from: range)!])
                    crArray.append(str)
                }
            }
            return crArray
        }
        return nil
    }
    
    func protocolEntites() -> [(String,String)]? { //返回实体的名字和匹配的字符串
        let funcRegExpStr = "@interface\\s*([a-zA-Z_0-9]+)\\s*:[a-zA-Z_0-9\\s]+(@property[a-zA-Z_,0-9\\s\\*\\(\\)]+;\\s*)+@end"
        if let regx = try? NSRegularExpression.init(pattern: funcRegExpStr, options: .dotMatchesLineSeparators) {
            let checkResult = regx.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            
            guard checkResult.count != 0 else {return nil}
            
            var resultArray = [(String,String)]()
            for rItem in checkResult {
                let nameRange = rItem.range(at: 1)
                let fullRange = rItem.range(at: 0)
                let entityName = String(self[range2(from: nameRange)!])
                let fullStr = String(self[range2(from: fullRange)!])
                resultArray.append((entityName,fullStr))
            }
            return resultArray
        }
        return nil;
    }
    
    func propertyNameType() -> [(String,String)]? {
        //@property (nonatomic, strong) NSString * goodsId;
        let funcRegExpStr = "@property\\s*\\([a-zA-Z,0-9_\\s]+\\)\\s*([a-zA-Z0-9_]+\\s*\\*?)\\s*([a-zA-Z0-9_]+)\\s*;"
        if let regx = try? NSRegularExpression.init(pattern: funcRegExpStr, options: .dotMatchesLineSeparators) {
            let checkResult = regx.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            
            guard checkResult.count != 0 else {return nil}
            
            var resultArray = [(String,String)]()
            for rItem in checkResult {
                let nameRange = rItem.range(at: 2)
                let typeRange = rItem.range(at: 1)
                let entityName = String(self[range2(from: nameRange)!])
                let type = String(self[range2(from: typeRange)!])
                resultArray.append((type,entityName))
            }
            return resultArray
        }
        return nil;
    }
    
    func interfaceWithParams() -> [String]?{
        //找到带参数匹配的所有接口，再需要继续子查询
        let funcRegExpStr = "[\\+|-]\\s*\\(\\s*[a-zA-Z<>\\s\\*_,]+\\s*\\*?\\s*\\)(\\s*[a-zA-Z_0-9]+:\\s*\\(\\s*[a-zA-Z<>\\s\\*_,]+\\s*\\*?\\s*\\)\\s*[a-zA-Z_0-9]+)+\\s*;"
        return self.range(regx: funcRegExpStr)
    }
    
    func interfaceNoParams() -> [String]? {
        //找到不带参数匹配的所有接口
        let funcRegExpStr = "[\\+|-]\\s*\\(\\s*([a-zA-Z<>\\s\\*_,]+\\s*\\*?)\\s*\\)\\s*[a-zA-Z_0-9]+\\s*;";
        return self.range(regx: funcRegExpStr)
    }
    
    //null_unspecified NSArray < NSDictionary * > *
    func fucReNSObjType() -> String? { //提取参数类型比如 NSString *
        let funcRegExpStr = "NS[a-zA-Z<>\\*\\s,_]+\\*"
        guard let rArray = self.range(regx: funcRegExpStr) else { return nil }
        
        return rArray[0]
    }
    
    func interfaceNoParamsFName() -> String? {
         let funcRegExpStr = "[\\+|-]\\s*\\(\\s*([a-zA-Z<>\\s\\*_,]+\\s*\\*?)\\s*\\)\\s*([a-zA-Z_0-9]+)\\s*;";
        if let regx = try? NSRegularExpression.init(pattern: funcRegExpStr, options: .dotMatchesLineSeparators) {
            let checkResult = regx.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            
            guard checkResult.count != 0 else {return nil}
            
            let range = checkResult[0].range(at: 2)
            if(range.location != NSNotFound){
                return String(self[range2(from: range)!])
            }
        }
        return nil;
    }
    
    func interfaceValueType() -> String? {
        //提取函数返回类型
        let funcRegExpStr = "[\\+|-]\\s*\\(\\s*([a-zA-Z<>\\s\\*_,]+\\s*\\*?)\\s*\\)";
        if let regx = try? NSRegularExpression.init(pattern: funcRegExpStr, options: .dotMatchesLineSeparators) {
             let checkResult = regx.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            
            guard checkResult.count != 0 else {return nil}
            
            let range = checkResult[0].range(at: 1)
            if(range.location != NSNotFound){
                return String(self[range2(from: range)!])
            }
        }
        return nil;
    }
    
    func interfacePrefixValueType() -> String? {
        //提取函数返回部分，比如-(void) 
        let funcRegExpStr = "[\\+|-]\\s*\\(\\s*[a-zA-Z<>\\s\\*_,]+\\s*\\*?\\s*\\)"
        guard let result = self.range(regx: funcRegExpStr) else {
            return nil;
        }
        return result[0]
    }
    
    func interfaceFunctionNameTypeParamsName() -> [(String,String,String)]? {
        //提取函数的参数名称
        let funcRegExpStr = "\\s*([a-zA-Z_0-9]+):(\\s*\\(\\s*[a-zA-Z<>\\s\\*_,]+\\s*\\*?\\s*\\))\\s*([a-zA-Z_0-9]+)"
        if let regx = try? NSRegularExpression.init(pattern: funcRegExpStr, options: .dotMatchesLineSeparators) {
            let checkResultArray = regx.matches(in: self, options: [], range: NSMakeRange(0, self.count))
           // print("checkResultArray)
            guard checkResultArray.count != 0 else {return nil}
            
            var resultArray = [(String,String,String)]()
            for cr in checkResultArray {
                let paramRange = cr.range(at: 3)
                let typeRange = cr.range(at: 2)
                let funcRange = cr.range(at: 1)
                if paramRange.location != NSNotFound {
                    let paramStr = String(self[range2(from: paramRange)!])
                    let funcStr = String(self[range2(from: funcRange)!])
                    let typeStr = String(self[range2(from: typeRange)!])
                    resultArray.append((funcStr,typeStr,paramStr))
                }
            }
            return resultArray
        }
        return nil;
    }
    

    
}



//test()
//buildTargetActionPRJ()
//buildPartCommondPRJ()

run_target_action_commond()


