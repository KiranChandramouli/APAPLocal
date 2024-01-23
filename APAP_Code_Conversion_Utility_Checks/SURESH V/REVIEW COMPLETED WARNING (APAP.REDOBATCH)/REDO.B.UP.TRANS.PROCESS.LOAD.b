* @ValidationCode : MjoxMTQxMTgwODIxOkNwMTI1MjoxNzA0NDQ1NjUxOTM4OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Jan 2024 14:37:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.UP.TRANS.PROCESS.LOAD
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SAKTHI
* Program Name  : REDO.B.TRANS.PROCESS.LOAD
* ODR           : ODR-2010-08-0031
*-----------------------------------------------------------------------------
* Description: This routine is a load routine used to load the variables
*-----------------------------------------------------------------------------
* In parameter :
* out parameter : None
*-----------------------------------------------------------------------------
* MODIFICATION HISTORY
*-----------------------------------------------------------------------------
*   DATE         WHO                    ODR                   DESCRIPTION
*============    ==============         ================      ================
*19-10-2010      Sakthi Sellappillai    ODR-2010-08-0031      Initial Creation
* 04-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*18/01/2024         Suresh          R22 UTILITY AUTO CONVERSION   Change F.READ to F.READU
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_BATCH.FILES
    $INSERT I_REDO.B.UP.TRANS.PROCESS.COMMON
    $INSERT I_F.REDO.SUPPLIER.PAYMENT
    $INSERT I_F.REDO.FILE.DATE.PROCESS
    $INSERT I_F.REDO.ISSUE.EMAIL
    $INSERT I_F.REDO.SUPPLIER.PAY.DATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.EB.EXTERNAL.USER
    $INSERT I_F.REDO.APAP.PARAM.EMAIL

    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    FN.REDO.SUPPLIER.PAYMENT = 'F.REDO.SUPPLIER.PAYMENT'
    F.REDO.SUPPLIER.PAYMENT = ''
    CALL OPF(FN.REDO.SUPPLIER.PAYMENT,F.REDO.SUPPLIER.PAYMENT)
    R.REDO.SUPPLIER.PAYMENT = ''
    FN.REDO.FILE.DATE.PROCESS = 'F.REDO.FILE.DATE.PROCESS'
    F.REDO.FILE.DATE.PROCESS  = ''
    CALL OPF(FN.REDO.FILE.DATE.PROCESS,F.REDO.FILE.DATE.PROCESS)
    FN.REDO.SUPPLIER.PAY.DATE = 'F.REDO.SUPPLIER.PAY.DATE'
    F.REDO.SUPPLIER.PAY.DATE = ''
    CALL OPF(FN.REDO.SUPPLIER.PAY.DATE,F.REDO.SUPPLIER.PAY.DATE)
    R.REDO.SUPPLIER.PAY.DATE = ''
    Y.REDO.SUPP.ERR = ''
    FN.OFS.RESPONSE.QUEUE = 'F.OFS.RESPONSE.QUEUE'
    F.OFS.RESPONSE.QUEUE = ''
    CALL OPF(FN.OFS.RESPONSE.QUEUE,F.OFS.RESPONSE.QUEUE)
    FN.REDO.APAP.PARAM.EMAIL = 'F.REDO.APAP.PARAM.EMAIL'
    F.REDO.APAP.PARAM.EMAIL = ''
    CALL OPF(FN.REDO.APAP.PARAM.EMAIL,F.REDO.APAP.PARAM.EMAIL)

    FN.REDO.EB.USER.PRINT.VAR='F.REDO.EB.USER.PRINT.VAR'
    F.REDO.EB.USER.PRINT.VAR=''
    CALL OPF(FN.REDO.EB.USER.PRINT.VAR,F.REDO.EB.USER.PRINT.VAR)



    R.OFS.RESPONSE.QUEUE = ''
    Y.OFS.RES.ERR = ''
    Y.LOC.FT.IDEN.TYPE.POS = ''
    Y.LOC.FT.INV.NO.POS = ''
    Y.LOC.FT.NCF.NUM.POS = ''
    Y.OFS.MSG.ID.VAL = ''
    Y.SUPPLIER.PAY.LIST = ''
    Y.PAY.SUP.PAY.STRING = ''
    Y.PAY.SUP.PAY.FAILURE.DESC = ''
    FN.REDO.ISSUE.MAIL = 'F.REDO.ISSUE.EMAIL'
    F.REDO.ISSUE.MAIL = ''
    R.REDO.ISSUE.MAIL = ''
    Y.ISSUE.EMAIL.ERR = ''
    CALL OPF(FN.REDO.ISSUE.MAIL,F.REDO.ISSUE.MAIL)

*  CALL F.READ(FN.REDO.ISSUE.MAIL,'SYSTEM',R.REDO.ISSUE.MAIL,F.REDO.ISSUE.MAIL,Y.ISSUE.EMAIL.ERR) ;*Tus Start
*    CALL CACHE.READ(FN.REDO.ISSUE.MAIL,'SYSTEM',R.REDO.ISSUE.MAIL,Y.ISSUE.EMAIL.ERR) ; * Tus End
    IDVAR.1 = 'SYSTEM' ;* R22 UTILITY AUTO CONVERSION
    CALL CACHE.READ(FN.REDO.ISSUE.MAIL,IDVAR.1,R.REDO.ISSUE.MAIL,Y.ISSUE.EMAIL.ERR) ; * Tus End;* R22 UTILITY AUTO CONVERSION
    IF R.REDO.ISSUE.MAIL THEN
        Y.FROM.MAIL.ADD.VAL =  R.REDO.ISSUE.MAIL<ISS.ML.MAIL.ID>
    END
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    R.CUSTOMER.REC = ''
    Y.CUST.ERR = ''
    FN.EB.EXTERNAL.USER = 'F.EB.EXTERNAL.USER'
    F.EB.EXTERNAL.USER = ''
    CALL OPF(FN.EB.EXTERNAL.USER,F.EB.EXTERNAL.USER)
    R.EB.EXTERNAL.USER.REC = ''
    Y.EXT.USER.ERR = ''


*    CALL CACHE.READ(FN.REDO.APAP.PARAM.EMAIL,'SYSTEM',R.EMAIL,MAIL.ERR)
    IDVAR.1 = 'SYSTEM' ;* R22 UTILITY AUTO CONVERSION
    CALL CACHE.READ(FN.REDO.APAP.PARAM.EMAIL,IDVAR.1,R.EMAIL,MAIL.ERR);* R22 UTILITY AUTO CONVERSION
    Y.FILE.PATH   = R.EMAIL<REDO.PRM.MAIL.IN.PATH.MAIL>
    Y.ATTACH.PATH = R.EMAIL<REDO.PRM.MAIL.ATTACH.PATH.MAIL>


    FN.HRMS.DET.FILE        = Y.FILE.PATH
    F.HRMS.DET.FILE         = ""
    CALL OPF(FN.HRMS.DET.FILE,F.HRMS.DET.FILE)

    FN.HRMS.ATTACH.FILE        = Y.ATTACH.PATH
    F.HRMS.ATTACH.FILE         = ""
    CALL OPF(FN.HRMS.ATTACH.FILE,F.HRMS.ATTACH.FILE)

    R.RECORD = ''
    R.RECORD1 = ''
    Y.TO.MAIL.VALUE = ''
    Y.CUST.RETRY = ''
    Y.EXT.USER.RETRY = ''
    Y.TRANS.DATE = ''
    Y.TRANS.TIME = ''
    Y.UNIQUE.ID = ''
    Y.REQUEST.FILE = ''
    Y.ATTACH.FILENAME = ''
    Y.VAR.EXT.CUSTOMER = ''
    Y.REL.CUST.VAL = ''
    APPL.ARRAY = "EB.EXTERNAL.USER"
    FIELD.ARRAY = "L.CORP.EMAIL"
    FIELD.POS = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FIELD.ARRAY,FIELD.POS)
    Y.LOC.CORP.EMAIL.POS = FIELD.POS<1,1>
RETURN
END
*-----------------------------------------------------------------------------
