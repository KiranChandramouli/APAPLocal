SUBROUTINE REDO.B.CONV.FILE.LOAD
*-------------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Sakthi Sellappillai
* Program Name  : REDO.B.CONV.FILE.LOAD
* ODR           : ODR-2010-08-0031
*-------------------------------------------------------------------------------------
* Description: This routine is a load routine used to load the variables
*-------------------------------------------------------------------------------------
* out parameter : None
*-------------------------------------------------------------------------------------
* MODIFICATION HISTORY
*-------------------------------------------------------------------------------------
*DATE               WHO                       ODR                  DESCRIPTION
*============       ====================      ==================   ==============
*19-10-2010         Sakthi Sellappillai       ODR-2010-08-0031     INITIAL CREATION
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_BATCH.FILES
    $INSERT I_F.EB.FILE.UPLOAD.TYPE
    $INSERT I_F.EB.FILE.UPLOAD.PARAM
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.REDO.FILE.DATE.PROCESS
    $INSERT I_F.REDO.SUPPLIER.PAYMENT
    $INSERT I_REDO.B.CONV.FILE.COMMON
    $INSERT I_F.REDO.SUPPLIER.PAY.DATE
    $INSERT I_F.AI.REDO.ACCT.RESTRICT.PARAMETER
    $INSERT I_F.AI.REDO.ARCIB.PARAMETER
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.FT.CHARGE.TYPE
*   $INSERT I_F.ACCOUNT
    GOSUB INITIALISE
    GOSUB PROCESS
    GOSUB GOEND
RETURN
*-------------------------------------------------------------------------------------
INITIALISE:
*-------------------------------------------------------------------------------------

    FN.FILE.UP.TYPE='F.EB.FILE.UPLOAD.TYPE'
    F.FILE.UP.TYPE=''
    R.UP.TYPE = ''
    UP.TYPE.ERR = ''
    CALL OPF(FN.FILE.UP.TYPE,F.FILE.UP.TYPE)

    FN.REDO.SUPPLIER.PAYMENT = 'F.REDO.SUPPLIER.PAYMENT'
    F.REDO.SUPPLIER.PAYMENT = ''
    R.REDO.SUPPLIER.PAYMNET = ''
    Y.REDO.SUPPLIER.PAY.ERR = ''
    CALL OPF(FN.REDO.SUPPLIER.PAYMENT,F.REDO.SUPPLIER.PAYMENT)


    FN.AI.REDO.ARCIB.PARAMETER = 'F.AI.REDO.ARCIB.PARAMETER'
    F.AI.REDO.ARCIB.PARAMETER  = ''
    CALL OPF(FN.AI.REDO.ARCIB.PARAMETER,F.AI.REDO.ARCIB.PARAMETER)

    FN.FT.TXN.TYPE.CONDITION = 'F.FT.TXN.TYPE.CONDITION'
    F.FT.TXN.TYPE.CONDITION = ''
    R.FT.TXN.TYPE.CONDITION = ''
    CALL OPF(FN.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION)

    FN.FT.COMMISSION.TYPE = 'F.FT.COMMISSION.TYPE'
    F.FT.COMMISSION.TYPE  = ''
    R.FT.COMMISSION.TYPE  = ''
    CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)

    FN.FT.CHARGE.TYPE = 'F.FT.CHARGE.TYPE'
    F.FT.CHARGE.TYPE  = ''
    R.FT.CHARGE.TYPE  = ''
    CALL OPF(FN.FT.CHARGE.TYPE,F.FT.CHARGE.TYPE)

    FN.REDO.FILE.DATE.PROCESS = 'F.REDO.FILE.DATE.PROCESS'
    F.REDO.FILE.DATE.PROCESS = ''
    R.REDO.FILE.DATE.PROCESS = ''
    Y.REDO.FILE.DATE.PRO.ERR = ''
    CALL OPF(FN.REDO.FILE.DATE.PROCESS,F.REDO.FILE.DATE.PROCESS)

    FN.EB.FILE.UPLOAD.PARAM = 'F.EB.FILE.UPLOAD.PARAM'
    R.EB.FILE.UPLOAD.PARAM = ''
    Y.EB.FILE.UPLOAD.PARMA.ERR = ''

    FN.REDO.SUPPLIER.PAY.DATE = 'F.REDO.SUPPLIER.PAY.DATE'
    F.REDO.SUPPLIER.PAY.DATE = ''
    R.REC.SUP.PAY = ''
    CALL OPF(FN.REDO.SUPPLIER.PAY.DATE,F.REDO.SUPPLIER.PAY.DATE)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    R.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    ERR = ''
    RETRY = ''
    Y.DATE.VAL = ''
    Y.ID.ARRAY = ''
    Y.REDO.SUPPLIER.ID  = ''
    Y.DATE.ARRAY = ''
    Y.REDO.FILE.DATE.PRO.ID = ''
    Y.REDO.SUPPLIER.SEQ = ''
    Y.INIT.UPLOAD.VAL = ''
    Y.DUM.FILE.NAME = ''
    Y.DUM.FILE.NAME.SEC.VAL = ''
    Y.SYMBOL.DIR = ''
    Y.UPLOAD.DIR.VAL = ''
    Y.REDO.SUPP.ERR = ''
    Y.REDO.SUPP.RETRY = ''
    Y.SUPPPLIER.COMM.TYPE = ''
    Y.PAYROLL.COMM.TYPE = ''
    Y.SUP.COM.CODE = ''
    Y.PAY.COM.CODE = '';Y.FT.COM.FLAT.AMT='';Y.FT.COM.PERCENT='';
    Y.PAY.COM.FLAT.AMT = '';Y.PAY.CHG.FLAT.AMT = '';Y.PAY.COM.PERCENT = '';
    Y.SUP.COM.FLAT.AMT = '';Y.SUP.CHG.FLAT.AMT = '';Y.SUP.COM.PERCENT = '';
    Y.SUPPLIER.COMM.TYPE = ''
    Y.SUPPLIER.CHG.TYPE  = ''
RETURN
*-------------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------------

    CALL CACHE.READ(FN.EB.FILE.UPLOAD.PARAM,'SYSTEM',R.EB.FILE.UPLOAD.PARAM,Y.EB.FILE.UPLOAD.PARMA.ERR)
    IF NOT(Y.EB.FILE.UPLOAD.PARMA.ERR) THEN
        Y.UPLOAD.PARAM.VAL = R.EB.FILE.UPLOAD.PARAM<EB.UP.TC.UPLOAD.PATH>
    END


    CALL CACHE.READ(FN.AI.REDO.ARCIB.PARAMETER,'SYSTEM',R.AI.REDO.ARCIB.PARAMETER,AI.REDO.ARCIB.PARAMETER.ERR)
    IF NOT(AI.REDO.ARCIB.PARAMETER.ERR) THEN
        Y.PAYROLL.TXN.CODE  = R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.PAYROLL.TXN.CODE>
        Y.SUPPLIER.TXN.CODE = R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.SUPPLIER.TXN.CODE>
        Y.FILE.DEST.PATH    = R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.UPLOAD.PATH>
    END

    GOSUB PAYROLL.COMMISSION.PROCESS
    GOSUB SUPPLIER.COMMISSION.PROCESS

    CALL CACHE.READ(FN.FILE.UP.TYPE, 'UPLOAD', R.UP.TYPE, UP.TYPE.ERR)
    IF NOT(UP.TYPE.ERR) THEN
        Y.UPLOAD.DIR.VAL = R.UP.TYPE<EB.UT.UPLOAD.DIR>
    END
    Y.SYMBOL.DIR = Y.UPLOAD.DIR.VAL[1,1]
    IF Y.SYMBOL.DIR NE '/' THEN
        Y.FILE.PATH = Y.UPLOAD.PARAM.VAL:"/":Y.UPLOAD.DIR.VAL
    END ELSE
        Y.FILE.PATH = Y.UPLOAD.PARAM.VAL:Y.UPLOAD.DIR.VAL
    END

    WERROR.MSG = ''
    OPEN Y.FILE.PATH ELSE

        WERROR.MSG =  'ARC File Upload Path Not Exist ' : Y.FILE.PATH

    END

    OPEN Y.FILE.DEST.PATH ELSE

        WERROR.MSG =  'ARC File Process Path Not Exist ' : Y.FILE.DEST.PATH

    END

    IF WERROR.MSG THEN
        GOSUB WRITE.ERROR.IN.LOG
    END

    FN.FILE.PATH = Y.FILE.PATH
    F.FILE.PATH  =''
    CALL OPF(FN.FILE.PATH,F.FILE.PATH)

    FN.FILE.PROC.PATH = Y.FILE.DEST.PATH
    F.FILE.PROC.PATH  = ''
    CALL OPF(FN.FILE.PROC.PATH,F.FILE.PROC.PATH)

RETURN
*-------------------------------------------------------------------------------------
WRITE.ERROR.IN.LOG:
*-------------------------------------------------------------------------------------

    FI.ARC.ACT.ID = "ARC001"
    INT.TYPE = 'BATCH'
    BAT.NO = '1'
    BAT.TOT = '1'
    INFO.OR = 'T24'
    INFO.DE = 'T24'
    ID.PROC = 'ARCUPLOAD'
    MON.TP  = '04'
    ID.DESC = 'ARCUPLOAD'
    REC.CON = WERROR.MSG
    EX.USER = OPERATOR ;
    EX.PC = ''
    CALL REDO.INTERFACE.REC.ACT(FI.ARC.ACT.ID,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,ID.DESC,REC.CON,EX.USER,EX.PC)
RETURN
*-------------------------------------------------------------------------------------
PAYROLL.COMMISSION.PROCESS:
*-------------------------------------------------------------------------------------

    CALL CACHE.READ(FN.FT.TXN.TYPE.CONDITION, Y.PAYROLL.TXN.CODE, R.FT.TXN.TYPE.CONDITION, FT.TXN.TYPE.CONDITION.ERR)
    Y.PAYROLL.COMM.TYPE       = R.FT.TXN.TYPE.CONDITION<FT6.COMM.TYPES>
    Y.PAYROLL.CHG.TYPE  = R.FT.TXN.TYPE.CONDITION<FT6.CHARGE.TYPES>
    IF Y.PAYROLL.CHG.TYPE THEN
        Y.PAYROLL.CHG.TYPE<2,-1> = 'CHG'
    END

    IF Y.PAYROLL.COMM.TYPE THEN
        CALL CACHE.READ(FN.FT.COMMISSION.TYPE, Y.PAYROLL.COMM.TYPE, R.FT.COMMISSION.TYPE, FT.COMMISSION.TYPE.ERR)
        Y.PAY.COM.FLAT.AMT = R.FT.COMMISSION.TYPE<FT4.FLAT.AMT,1>
        Y.PAY.COM.PERCENT = R.FT.COMMISSION.TYPE<FT4.PERCENTAGE,1,1>
    END


RETURN
*-------------------------------------------------------------------------------------
SUPPLIER.COMMISSION.PROCESS:
*-------------------------------------------------------------------------------------

    CALL CACHE.READ(FN.FT.TXN.TYPE.CONDITION, Y.SUPPLIER.TXN.CODE, R.FT.TXN.TYPE.CONDITION, FT.TXN.TYPE.CONDITION.ERR)
    Y.SUPPLIER.COMM.TYPE = R.FT.TXN.TYPE.CONDITION<FT6.COMM.TYPES>
    Y.PAYROLL.CHG.TYPE  = R.FT.TXN.TYPE.CONDITION<FT6.CHARGE.TYPES>
    IF Y.PAYROLL.CHG.TYPE THEN
        Y.PAYROLL.CHG.TYPE<2,-1> = 'CHG'
    END


    IF Y.SUPPLIER.COMM.TYPE THEN
        CALL CACHE.READ(FN.FT.COMMISSION.TYPE, Y.SUPPLIER.COMM.TYPE, R.FT.COMMISSION.TYPE, FT.COMMISSION.TYPE.ERR)
        Y.SUP.COM.FLAT.AMT = R.FT.COMMISSION.TYPE<FT4.FLAT.AMT,1>
        Y.SUP.COM.PERCENT  = R.FT.COMMISSION.TYPE<FT4.PERCENTAGE,1,1>
    END

RETURN
*-------------------------------------------------------------------------------------
GOEND:
*-------------------------------------------------------------------------------------
END
*----------------------------* END OF SUBROUTINE*-------------------------------------
