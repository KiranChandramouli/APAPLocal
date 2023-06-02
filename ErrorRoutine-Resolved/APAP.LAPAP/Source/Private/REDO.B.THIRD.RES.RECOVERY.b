* @ValidationCode : MjoxMTE1NTI0MzU1OkNwMTI1MjoxNjg1MDg0NDg3NzU0OmhhaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 May 2023 12:31:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : hai
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.THIRD.RES.RECOVERY(Y.AA.ARR.ID)
*---------------------------------------------------------------------------------------------
*
* Description           : Batch routine to report information about files with tax data checks and electronic transfer that should be send to the Government Entity (SB)

* Developed By          : Thilak Kumar K
*
* Development Reference :
*
* Attached To           : Batch - BNK/REDO.B.THIRD.RES.RECOVERY
*
* Attached As           : Online Batch Routine to COB
*---------------------------------------------------------------------------------------------
* Input Parameter:
*----------------*
* Argument#1 : Y.AA.ARR.ID -@ID of AA.ARRANGEMENT application
*
*-----------------*
* Output Parameter:
*-----------------*
* Argument#4 : NA
*
*---------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*---------------------------------------------------------------------------------------------
*   Date       Author              Modification                    Description
*29/10/2014  Ashokkumar.V.P         PACS00353049 -                 New mapping changes
*12/03/2015  Ashokkumar.V.P         PACS00353049 -                 Added to fetch balance from TOTCOMMITMENT and rate field fix.
*24/05/2023   Ghayathri T           MANUAL R22 CODE CONVERSION     Call routine modified,Changed AA.AH.ACTIVITY.ID to AA.AH.ACTIVITY.REF
*24/05/2023   Ghayathri T           AUTO R22 CODE CONVERSI         NEWLINES ADD,SM,VM,&FM CHANGE TO @SM,@VM,@FM
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.INTEREST.ACCRUALS
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_BATCH.FILES
    $INSERT I_F.CURRENCY
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.INTEREST
*   $INSERT I_F.AA.INTEREST.ACCRUALS
    $INSERT I_REDO.B.THIRD.RES.RECOVERY.COMMON
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $USING APAP.REDOCHNLS
    


*
    GOSUB PROCESS
RETURN

PROCESS:
*-------
*
    R.ARRANGEMENT='';R.AA.INTEREST.ACCRUALS='';Y.DATE1='';Y.MAT.DATE='';Y.TERM='';Y.BASIS='';Y.TERM.DAYS='';Y.LEN='';Y.CAL.TERM='';Y.DAYS=''
    CALL AA.GET.ARRANGEMENT(Y.AA.ARR.ID,R.ARRANGEMENT,ARR.ERR)
    Y.PRODUCT.GROUP  = R.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
    Y.PRODUCT.LINE  = R.ARRANGEMENT<AA.ARR.PRODUCT.LINE>
    Y.ARR.CURRENCY   = R.ARRANGEMENT<AA.ARR.CURRENCY>
    Y.LINKED.APPL    = R.ARRANGEMENT<AA.ARR.LINKED.APPL>
    Y.LINKED.ID      = R.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
    Y.ARR.STATUS     = R.ARRANGEMENT<AA.ARR.ARR.STATUS>
    Y.CUSTOMER.ID    = R.ARRANGEMENT<AA.ARR.CUSTOMER>
    Y.START = R.ARRANGEMENT<AA.ARR.START.DATE,1>


    YLINEAS.FLG = 0
    IF Y.PRODUCT.GROUP EQ 'LINEAS.DE.CREDITO' THEN
        PFM = '';PVM = ''; PSM = ''
        FINDSTR 'COM' IN Y.PRODUCT.LINE SETTING PFM,PVM,PSM THEN
            YLINEAS.FLG = 1
            Y.PRODUCT.GROUP = "COMERCIAL"
        END
        PFM = '';PVM = ''; PSM = ''
        FINDSTR 'CONS' IN Y.PRODUCT.LINE SETTING PFM,PVM,PSM THEN
            YLINEAS.FLG = 1
            Y.PRODUCT.GROUP = "CONSUMO"
        END
        IF YLINEAS.FLG NE '1' THEN
            RETURN
        END
    END

    GOSUB GET.ACCOUNT.DETAILS

    R.AA.ARR.CUSTOMER = ''
    PROP.CLASS        = 'CUSTOMER'
    GOSUB GET.ARRANGEMENT
    R.AA.ARR.CUSTOMER = RAISE(returnConditions)
    Y.AA.CAMP.TY = R.AA.ARR.CUSTOMER<AA.CUS.LOCAL.REF,Y.CU.CAMP.POS>
*
    IF (Y.AA.CAMP.TY EQ Y.AA.CAMY.TY.VAL) AND (YCLOSE.DATE EQ Y.TODATE) THEN
        GOSUB GET.TERM.AMOUNT.DETS
        GOSUB GET.INTEREST.RATE
        GOSUB GET.DISBURSED.AMOUNT
        GOSUB GET.BENF.DETS
    END
RETURN

GET.ACCOUNT.DETAILS:
*-----------------
    LOCATE "ACCOUNT" IN Y.LINKED.APPL<1,1> SETTING Y.LINKED.POS THEN
        Y.FINAL.MSG = ""; Y.FINAL.AMT = ""; Y.FINAL.DAYS = ""
        Y.NROPRESTAMO  = Y.LINKED.ID<1,Y.LINKED.POS>
    END
    R.ACCOUNT = ''; ERRR.ACCT = ''; YCLOSE.DATE = ''
    CALL F.READ(FN.ACCOUNT,Y.NROPRESTAMO,R.ACCOUNT,F.ACCOUNT,ERRR.ACCT)
    IF NOT(R.ACCOUNT) THEN
        ERRR.ACCT = ''; Y.NROPRESTAMO.HIS = Y.NROPRESTAMO
        CALL EB.READ.HISTORY.REC(F.ACCOUNT.HIS,Y.NROPRESTAMO.HIS,R.ACCOUNT,ERRR.ACCT)
    END
    YCLOSE.DATE = R.ACCOUNT<AC.CLOSURE.DATE>
RETURN

GET.ARRANGEMENT:
*---------------
*
    ARRANGEMENT.ID    = Y.AA.ARR.ID
    PROP.NAME         = ''
    RET.ERR           = ''
    returnID          = ''
    returnConditions  = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ARRANGEMENT.ID,PROP.CLASS,PROP.NAME,'',returnID,returnConditions,RET.ERR)
*
RETURN
*---------------------------------------------------------------------------------------------
GET.EFFECTIVE.DATE:
*------------------

    ARR.INFO      = ''; Y.DATE = ''
    ARR.INFO<1>   = Y.AA.ARR.ID
    R.ARRANGEMENT = ''
    Y.EFF.DATE    = Y.TODATE
    CALL AA.GET.ARRANGEMENT.PROPERTIES(ARR.INFO,Y.EFF.DATE,R.ARRANGEMENT,PROP.LIST)

    REQD.MODE = ''; EFF.DATE = Y.START; R.AA.ACTIVITY.HISTORY = ''
    CALL AA.READ.ACTIVITY.HISTORY(Y.AA.ARR.ID, REQD.MODE, EFF.DATE, R.AA.ACTIVITY.HISTORY)
    Y.MIG.ACTIVITY = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY>
    YACT.ID.ARR = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY.REF>;* R22 Manual Conversion Changed AA.AH.ACTIVITY.ID to AA.AH.ACTIVITY.REF

    LOCATE "LENDING-TAKEOVER-ARRANGEMENT" IN YACT.ID.ARR<1,1> SETTING Y.POS.MIG THEN
        Y.DATE =R.ARRANGEMENT <AA.ARR.ORIG.CONTRACT.DATE>
    END

    IF NOT(Y.DATE) THEN
        LOCATE "LENDING-DISBURSE-COMMITMENT" IN YACT.ID.ARR<1,1> SETTING YPOS.MIG THEN
            Y.DATE =R.AA.ACTIVITY.HISTORY<AA.AH.EFFECTIVE.DATE,YPOS.MIG,1>
        END
    END
RETURN
*---------------------------------------------------------------------------------------------
GET.TERM.AMOUNT.DETS:
*--------------------
*
    R.AA.TERM.AMOUNT  = ''
    PROP.CLASS        = 'TERM.AMOUNT'
    GOSUB GET.EFFECTIVE.DATE
    GOSUB GET.ARRANGEMENT
    R.AA.TERM.AMOUNT  = RAISE(returnConditions)
*
    Y.MATURITY.DATE = R.AA.TERM.AMOUNT<AA.AMT.MATURITY.DATE>
*
    Y.TERM  = R.AA.TERM.AMOUNT<AA.AMT.TERM>
    Y.BASIS = RIGHT(Y.TERM,1)
*
    BEGIN CASE
        CASE Y.BASIS EQ 'D'
            Y.TERM.DAYS = Y.TERM
        CASE Y.BASIS EQ 'M'
            Y.LEN        = LEN(Y.TERM)
            Y.CAL.TERM   = LEFT(Y.TERM,Y.LEN-1)
            Y.DAYS       = Y.CAL.TERM*30
            Y.TERM.DAYS  = Y.DAYS:'D'
        CASE Y.BASIS EQ 'Y'
            Y.LEN        = LEN(Y.TERM)
            Y.CAL.TERM   = LEFT(Y.TERM,Y.LEN-1)
            Y.DAYS       = Y.CAL.TERM*365
            Y.TERM.DAYS  = Y.DAYS:'D'
    END CASE
*
    Y.DATE1      = Y.DATE[7,2]:Y.DATE[5,2]:Y.DATE[1,4]
    Y.MAT.DATE   = Y.MATURITY.DATE[7,2]:Y.MATURITY.DATE[5,2]:Y.MATURITY.DATE[1,4]
    C$SPARE(451) = Y.DATE1
    C$SPARE(452) = Y.MAT.DATE
    C$SPARE(453) = Y.TERM.DAYS
RETURN

GET.INTEREST.RATE:
******************
    INT.ID = Y.AA.ARR.ID:'-PRINCIPALINT'
    R.AA.INTEREST.ACCRUALS = ''; AA.INTEREST.ACCRUALS.ERR = ''; Y.INT.RATE = ''
    CALL F.READ(FN.AA.INTEREST.ACCRUALS,INT.ID,R.AA.INTEREST.ACCRUALS,F.AA.INTEREST.ACCRUALS,AA.INTEREST.ACCRUALS.ERR)
    IF R.AA.INTEREST.ACCRUALS THEN
        Y.INT.RATE = R.AA.INTEREST.ACCRUALS<AA.INT.ACC.RATE,1>
        IF Y.INT.RATE EQ '' THEN
            GOSUB GET.INTEREST.ACCRUALS.DETS
        END
        C$SPARE(454) = Y.INT.RATE
    END
RETURN

GET.INTEREST.ACCRUALS.DETS:
*--------------------------
    ArrangementID = Y.AA.ARR.ID; idProperty = 'PRINCIPALINT'; EFF.RATE = ''
    idPropertyClass = ''; effectiveDate = ''; returnIds = ''; returnConditions = ''; returnError = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    R.AA.INTEREST = RAISE(returnConditions)
    CNT.RATE = DCOUNT(R.AA.INTEREST<AA.INT.EFFECTIVE.RATE>,'VM')
    Y.INT.RATE = R.AA.INTEREST<AA.INT.EFFECTIVE.RATE,CNT.RATE>
RETURN


GET.DISBURSED.AMOUNT:
*--------------------
*
    CALL F.READ(FN.EB.CONTRACT.BALANCES,Y.NROPRESTAMO,R.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES,Y.ECB.ERR)
    Y.TYPE.SYSDATE = R.EB.CONTRACT.BALANCES<ECB.TYPE.SYSDATE>
    Y.CURRENCY     = R.EB.CONTRACT.BALANCES<ECB.CURRENCY>
    YASST.TPE.VAL = R.EB.CONTRACT.BALANCES<ECB.CURR.ASSET.TYPE>
    LOCATE 'TOTCOMMITMENT' IN YASST.TPE.VAL<1,1> SETTING TOTCOMMITMENT.POS THEN
        OPEN.BAL = R.EB.CONTRACT.BALANCES<ECB.OPEN.BALANCE,TOTCOMMITMENT.POS>
        CHANGE @SM TO '+' IN OPEN.BAL
        Y.AMOUNT = ABS(OPEN.BAL)
    END
*
    IF Y.CURRENCY NE LCCY THEN
        CALL F.READ(FN.CURRENCY,Y.ARR.CURRENCY,R.CURRENCY,F.CURRENCY,Y.CUR.ERR)
        Y.CURR.MRKT = R.CURRENCY<EB.CUR.CURRENCY.MARKET>
        Y.MID.RATE  = R.CURRENCY<EB.CUR.MID.REVAL.RATE>
        CHANGE @VM TO @FM IN Y.MID.RATE
*
        LOCATE "1" IN Y.CURR.MRKT<1,1> SETTING Y.RATE.POS THEN
            Y.MID.REVAL.RATE = Y.MID.RATE<Y.RATE.POS>
        END
*
        Y.DISB.AMT = Y.AMOUNT * Y.MID.REVAL.RATE
*
    END ELSE
        Y.DISB.AMT = Y.AMOUNT
    END
    C$SPARE(455) = Y.DISB.AMT
RETURN
*---------------------------------------------------------------------------------------------
GET.BENF.DETS:
*-------------
    R.CUSTOMER = ''; CUS.ERR = ''; Y.L.CU.TIPO.CL = ''; Y.REL.CODE=''; OUT.ARR=''
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    Y.L.CU.TIPO.CL = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS>

    APAP.LAPAP.redoSRegCustomerExtract(Y.CUSTOMER.ID,Y.PRODUCT.GROUP,Y.REL.CODE,OUT.ARR);*MANUAL R22 CODE CONVERSION
*
    Y.CUST.IDEN    = OUT.ARR<1>
    Y.CUST.NAME    = OUT.ARR<3>
    Y.CUST.GN.NAME = OUT.ARR<4>

    IF Y.L.CU.TIPO.CL EQ "PERSONA FISICA" OR Y.L.CU.TIPO.CL EQ "CLIENTE MENOR" THEN
        C$SPARE(456) = Y.CUST.NAME:' ':Y.CUST.GN.NAME
    END ELSE
        C$SPARE(456) = Y.CUST.NAME
    END
    C$SPARE(457) = Y.CUST.IDEN
*
    GOSUB MAP.RCL.REC
RETURN
*---------------------------------------------------------------------------------------------
MAP.RCL.REC:
*-----------
*
    MAP.FMT = "MAP"
    ID.RCON.L = 'REDO.RCL.RES.REC'
    APP = FN.AA.ARRANGEMENT
    R.APP  = R.ARRANGEMENT
    ID.APP = Y.AA.ARR.ID
    CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG)
    Y.ARRAY = Y.PRODUCT.GROUP:"*":Y.DISB.AMT:"*":R.RETURN.MSG
*
    Y.ARR<-1> = Y.DATE1:"*":Y.MAT.DATE:"*":Y.TERM.DAYS:"*":Y.INT.RATE:"*":Y.DISB.AMT:"*":Y.CUST.NAME:"*":Y.CUST.IDEN
    IF Y.ARRAY THEN
        WRITESEQ Y.ARRAY APPEND TO SEQ.PTR ELSE
            Y.ERR.MSG = "Unable to Write '":Y.FILE.NAME:"'"
            GOSUB RAISE.ERR.C.22
            RETURN
        END
    END
*
RETURN
*---------------------------------------------------------------------------------------------
*
RAISE.ERR.C.22:
*--------------
*Handling error process
*----------------------
*
    MON.TP    = "13"
    REC.CON   = "Recuperaciones de la Tercera Resolucion-":Y.ERR.MSG
    DESC      = "Recuperaciones de la Tercera Resolucion-":Y.ERR.MSG
    INT.CODE  = 'REP001'
    INT.TYPE  = 'ONLINE'
    BAT.NO    = ''
    BAT.TOT   = ''
    INFO.OR   = ''
    INFO.DE   = ''
    ID.PROC   = ''
    EX.USER   = ''
    EX.PC     = ''
    APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC);*MANUAL R22 CODE CONVERSION
*
RETURN
*---------------------------------------------------------------------------------------------
END
