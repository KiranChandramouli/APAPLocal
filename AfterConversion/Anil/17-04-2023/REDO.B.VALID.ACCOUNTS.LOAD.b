* @ValidationCode : MjotMjk2NjQ0MDM3OkNwMTI1MjoxNjgxNzA4MDUzMzQzOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 17 Apr 2023 10:37:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.VALID.ACCOUNTS.LOAD
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : NATCHIMUTHU
* Program Name  : REDO.B.VALID.ACCOUNTS.LOAD
* ODR           : ODR-2010-09-0171
*-------------------------------------------------------------------------
* Description: This routine is a load routine used to load the variables
*
*
*---------------------------------------------------------------------------
* Linked with:
* In parameter :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*-------------------------------------------------------------------------
*   DATE          WHO                   ODR                  DESCRIPTION
*   08-10-10      NATCHIMUTHU          ODR-2010-09-0171      Initial Creation
* Date                  who                   Reference
* 17-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - FM TO @FM AND VM TO @VM AND SESSION.NO TO AGENT.NUMBER AND ADD I_TSA.COMMON
* 17-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -REMOVING THE SPACE IN PYMNT.FILE
*------------------------------------------------------------------------
    $INSERT I_TSA.COMMON   ;*R22 AUTO CONVERSTION ADD I_TSA.COMMON
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.REDO.ACCT.STATUS.CODE
    $INSERT I_F.REDO.APAP.H.PARAMETER
    $INSERT I_REDO.B.VALID.ACCOUNTS.COMMON
    $INSERT I_F.REDO.APAP.CLEAR.PARAM

    GOSUB INIT
RETURN

*******
INIT:
*******

    FN.REDO.INTERFACE.PARAM = "F.REDO.INTERFACE.PARAM"
    F.REDO.INTERFACE.PARAM = ""
    R.REDO.INTERFACE.PARAM = ""
    Y.REDO.INT.PAR.ERR = ""
    CALL OPF(FN.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM)

    FN.REDO.INTERFACE.ACT = "F.REDO.INTERFACE.ACT"
    F.REDO.INTERFACE.ACT = ""
    R.REDO.INTERFACE.ACT = ""
    Y.REDO.INT.ACT.ERR = ""
    CALL OPF(FN.REDO.INTERFACE.ACT,F.REDO.INTERFACE.ACT)

    FN.REDO.INTERFACE.ACT.DETAILS = "F.REDO.INTERFACE.ACT.DETAILS"
    F.REDO.INTERFACE.ACT.DETAILS = ""
    R.REDO.INTERFACE.ACT.DETAILS = ""
    Y.REDO.INT.ACT.DETS.ERR = ""
    CALL OPF(FN.REDO.INTERFACE.ACT.DETAILS,F.REDO.INTERFACE.ACT.DETAILS)

    FN.REDO.INTERFACE.NOTIFY = "F.REDO.INTERFACE.NOTIFY"
    F.REDO.INTERFACE.NOTIFY = ""
    R.REDO.INTERFACE.NOTIFY = ""
    Y.REDO.INT.NOTIFY.ERR = ""
    CALL OPF(FN.REDO.INTERFACE.NOTIFY,F.REDO.INTERFACE.NOTIFY)

    FN.REDO.INTERFACE.MON.TYPE = "F.REDO.INTERFACE.MON.TYPE"
    F.REDO.INTERFACE.MON.TYPE = ""
    R.REDO.INTERFACE.MON.TYPE = ""
    Y.REDO.INT.MON.TYPE.ERR = ""
    CALL OPF(FN.REDO.INTERFACE.MON.TYPE,F.REDO.INTERFACE.MON.TYPE)

    FN.REDO.APAP.H.PARAMETER = 'F.REDO.APAP.H.PARAMETER'
    F.REDO.APAP.H.PARAMETER = ''
    CALL OPF(FN.REDO.APAP.H.PARAMETER,F.REDO.APAP.H.PARAMETER)

    FN.ACCOUNT =  'F.ACCOUNT'
    F.ACCOUNT  =  ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AC.HIS = 'F.ACCOUNT$HIS'
    F.AC.HIS = ''
    CALL OPF(FN.AC.HIS,F.AC.HIS)

    FN.AC.CLS = 'F.ACCOUNT.CLOSURE'
    F.AC.CLS = ''
    CALL OPF(FN.AC.CLS,F.AC.CLS)

    FN.REDO.ACCT.STATUS.CODE  =   'F.REDO.ACCT.STATUS.CODE'
    F.REDO.ACCT.STATUS.CODE   =   ''
    CALL OPF(FN.REDO.ACCT.STATUS.CODE,F.REDO.ACCT.STATUS.CODE)

    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER = ""
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.REDO.APAP.CLEAR.PARAM='F.REDO.APAP.CLEAR.PARAM'
    F.REDO.APAP.CLEAR.PARAM=''
    CALL OPF(FN.REDO.APAP.CLEAR.PARAM,F.REDO.APAP.CLEAR.PARAM)


    CALL CACHE.READ(FN.REDO.APAP.CLEAR.PARAM,'SYSTEM',R.REDO.APAP.CLEAR.PARAM,Y.ERR)

    Y.CATEG.APERTA = R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.CATEG.APERTA>
    CHANGE @VM TO @FM IN Y.CATEG.APERTA

    FN.CCY = 'F.CURRENCY'
    F.CCY = ''
    CALL OPF(FN.CCY,F.CCY)

    Y.LRF.APPL   = 'CUSTOMER':@FM:'ACCOUNT'
    Y.LRF.FIELDS = 'L.CU.CIDENT':@VM:'L.CU.NOUNICO':@VM:'L.CU.RNC':@VM:'L.CU.ACTANAC':@FM:'L.AC.STATUS':@VM:'L.AC.CHEK.DIGIT'
    FIELD.POS    = ''
    AC.STATUS2.POS = ''
    CALL MULTI.GET.LOC.REF(Y.LRF.APPL,Y.LRF.FIELDS,FIELD.POS)

    Y.L.CU.CIDENT.POS   = FIELD.POS<1,1>
    Y.L.CU.NOUNICO.POS  = FIELD.POS<1,2>
    Y.L.CU.RNC.POS      = FIELD.POS<1,3>
    Y.L.CU.ACTANAC.POS  = FIELD.POS<1,4>
    AC.STATUS2.POS = FIELD.POS<2,1>
    AC.CHK.DIG.POS = FIELD.POS<2,2>

    FN.LOCKING.C22 ='F.LOCKING'
    F.LOCKING.C22 =''
    CALL OPF(FN.LOCKING.C22,F.LOCKING.C22)

    CALL CACHE.READ(FN.REDO.APAP.H.PARAMETER,"SYSTEM",R.REDO.APAP.H.PARAMETER,PARAM.ERR)
    IF PARAM.ERR EQ '' THEN
        CCY.FILE.NAME = R.REDO.APAP.H.PARAMETER<PARAM.APERTA.FILE.NAME>
        CCY.OUT.PATH = R.REDO.APAP.H.PARAMETER<PARAM.APERTA.PATH,1>
        CCY.OUT.PATH.CP = CCY.OUT.PATH
        CCY.OUT.PATH.OUT = R.REDO.APAP.H.PARAMETER<PARAM.APERTA.PATH,2>
    END


    CALL CACHE.READ(FN.REDO.ACCT.STATUS.CODE,"SYSTEM",R.REDO.ACCT.STATUS.CODE,Y.ERR)
    IF Y.ERR EQ '' THEN
        Y.REDO.PREVAL.STATUS  = R.REDO.ACCT.STATUS.CODE<REDO.ACCT.STATUS.PREVAL.STATUS>
        Y.REDO.STATUS.CODE    = R.REDO.ACCT.STATUS.CODE<REDO.ACCT.STATUS.STATUS.CODE>
    END

    Y.FINAL.ARRAY = ''
    Y.FILE.PATH = ''
    Y.FILE.NAME = ''

    GET.FILE.NAME1 = FIELD(CCY.FILE.NAME,'.',1)
    GET.FILE.NAME2 = FIELD(CCY.FILE.NAME,'.',2)

    PYMNT.FILE = TODAY:GET.FILE.NAME1:".":GET.FILE.NAME2:"_":AGENT.NUMBER  ;*R22 AUTO CONVERSTION SESSION.NO TO AGENT.NUMBER


    OPENSEQ CCY.OUT.PATH,PYMNT.FILE TO F.FILE.NAME ELSE
        CREATE F.FILE.NAME ELSE
            OPEN.ERR = 'Unable to Open / Create ':CCY.OUT.PATH:" " PYMNT.FILE
            GOSUB C22.LOG
            RETURN
            CALL EXCEPTION.LOG("S","FT","CREATE.CRP.FILE","","001","",CCY.OUT.PATH,PYMNT.FILE,"",OPEN.ERR,"")  ;* R22 MANUAL CONVERSTION REMOVING THE SPACE IN PYMNT.FILE
        END
    END
    OPEN CCY.OUT.PATH.OUT TO F.CCY.OUT.PATH.OUT.CH ELSE

        OPEN.ERR= 'Unable to Open ':CCY.OUT.PATH.OUT
        GOSUB C22.LOG
    END
RETURN
*-------
C22.LOG:
*-------
    MON.TP = "04"
    REC.CON = OPEN.ERR
    DESC = OPEN.ERR
    INT.CODE = 'APA001'
    INT.TYPE = 'BATCH'
    BAT.NO = ''
    BAT.TOT = ''
    INFO.OR = ''
    INFO.DE = ''
    ID.PROC = ''
    EX.USER = ''
    EX.PC = ''
    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
RETURN
END
*-------------------------------------------------------------------------------------
* PROGRAM END
*---------------------------------------------------------------------------------------
