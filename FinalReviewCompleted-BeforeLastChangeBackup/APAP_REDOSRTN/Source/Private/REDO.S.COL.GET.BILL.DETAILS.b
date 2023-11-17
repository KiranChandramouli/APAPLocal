* @ValidationCode : Mjo1NjAwNjU5NTpDcDEyNTI6MTY4ODUzNjY1ODU5MDpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Jul 2023 11:27:38
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOSRTN
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 25-05-2023     Conversion tool    R22 Auto conversion       FM TO @FM, VM to @VM, SM to @SM, ++ to +=,I to I.VAR
* 25-05-2023      Harishvikram C   Manual R22 conversion      No changes
* 16-06-2023      Santosh        R22 Manual Code Conversion   Change funtion to subroutine

*-----------------------------------------------------------------------------
SUBROUTINE REDO.S.COL.GET.BILL.DETAILS(AA.ID,R.AA.ACCOUNT.DETAILS,  Y.PROCESS.DATE,  Y.MORA.CTA.VEN, Y.TMPCREDITODIASATRASO, Y.TMPCREDITOCUOTASVENCIDAS, Y.TMPCREDITOCUOTASPAGADAS, Y.TMPCREDITOMONTOMOROSO )
*******************************************************************************
*
*    COLLECTOR - Interface
*    Allows to get bill details INFO
*    Fields:
*        TMPCREDITO>TMPCREDITOMONTOMOROSO
*        TMPCREDITO>TMPCREDITODIASATRASO
*        TMPCREDITO>TMPCREDITOCUOTASVENCIDAS
*        TMPCREDITO>TMPCREDITOCUOTASPAGADAS
*
*   Input/Output
* ------------------------
*
* =============================================================================
*
*    First Release :  TAM
*    Developed for :  TAM
*    Developed by  :  APAP
*    Date          :  2010-11-15 C.1
*
*=======================================================================
*
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.ACCOUNT.DETAILS
*
    $INSERT I_REDO.COL.CUSTOMER.COMMON
    $USING APAP.TAM
*
*************************************************************************
*

    GOSUB INITIALISE
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
* ======
* Main Process
PROCESS:
* ======
*
*
    Y.TMPCREDITODIASATRASO = 0
    Y.TMPCREDITOCUOTASVENCIDAS = 0
    Y.TMPCREDITOCUOTASPAGADAS = 0
    Y.TMPCREDITOMONTOMOROSO = 0
    IF R.AA.ACCOUNT.DETAILS NE '' THEN
        Y.PREV.DATE = ''
        Y.NEXT.DATE = TODAY
        Y.CONT = DCOUNT(R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>,@VM)
        Y.BL.STATUS = "AGING"
        Y.ST.STATUS.EXP="UNPAID"

        I.VAR = 1
        LOOP
        WHILE I.VAR LE Y.CONT
            IF R.AA.ACCOUNT.DETAILS<AA.AD.BILL.PAY.DATE,I.VAR> GT Y.PROCESS.DATE THEN
                I.VAR = Y.CONT+1
            END ELSE
                GOSUB GET.BILL.AMOUNT.DETAILS
            END
            I.VAR += 1
        REPEAT

        IF Y.PREV.DATE NE '' THEN
            NO.OF.DAYS='C'
            CALL CDD('',Y.PREV.DATE,Y.NEXT.DATE,NO.OF.DAYS)
            Y.TMPCREDITODIASATRASO = NO.OF.DAYS
        END

* Get history bill status
        I.VAR = 1
        LOOP
        WHILE I.VAR LE Y.CONT
            IF R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE,I.VAR> EQ "PAYMENT" THEN
                GOSUB GET.DUE.DATES
            END
            I.VAR += 1
        REPEAT
    END

    FN.AA.ACCOUNT.DETAILS.HIST = 'F.AA.ACCOUNT.DETAILS.HIST'; F.AA.ACCOUNT.DETAILS = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS.HIST,F.AA.ACCOUNT.DETAILS.HIST)
    FN.AA.BILL.HST = 'F.AA.BILL.DETAILS.HIST'
    F.AA.BILL.HST = ''
    CALL OPF(FN.AA.BILL.HST,F.AA.BILL.HST)
    ERR.AA.ACCOUNT.DETAILS.HIST = ''; R.AA.ACCOUNT.DETAILS.HIST = ''; BILLS = ''; YCONT = 0
    CALL F.READ(FN.AA.ACCOUNT.DETAILS.HIST,AA.ID,R.AA.ACCOUNT.DETAILS.HIST,F.AA.ACCOUNT.DETAILS.HIST,ERR.AA.ACCOUNT.DETAILS.HIST)
    BILLS = R.AA.ACCOUNT.DETAILS.HIST<AA.AD.BILL.ID>
    YCONT = DCOUNT(BILLS,@VM)

    JI = 1
    LOOP
    WHILE JI LE YCONT

        R.BILL.DETAILS = ''; BILL.ERR = ''
        CALL F.READ(FN.AA.BILL.HST,Y.BILL.ID,R.BILL.DETAILS,F.AA.BILL.HST,BILL.ERR)
        IF R.BILL.DETAILS<AA.BD.BILL.TYPE> EQ 'PAYMENT' THEN
            Y.TMPCREDITOCUOTASPAGADAS += 1
        END
        JI += 1
    REPEAT
RETURN
*
*
* ---------
INITIALISE:
* ---------
*
    PROCESS.GOAHEAD = 1
* Generate the list of Last Day of the month, one year ago
* Position 1 is the last day of the month before
    COMI = Y.PROCESS.DATE
*   IF redoIsLastDay(Y.PROCESS.DATE) THEN         ;* PROCES.DATE is the last day of the current month ?
    IF APAP.TAM.redoIsLastDay(Y.PROCESS.DATE) THEN ;* R22 Manual Code Conversion - Change funtion to subroutine
        Y.DAY = Y.PROCESS.DATE[7,2]
        Y.DAY -= 1
        COMI = Y.PROCESS.DATE[1,6] : Y.DAY
    END

    Y.YEAR = COMI[1,4]
    Y.YEAR -= 1
    COMI = Y.YEAR : COMI[5,4]
    Y.MORA.DATES =  ""
    Y.MORA.CTA.VEN = ""
    FOR I.VAR = 12 TO 1 STEP -1   ;* We're ommited the position 12
        COMI = COMI[1,8] : "M0131"
        CALL CFQ
        Y.MORA.DATES<I.VAR>    = COMI[1,8]
        Y.MORA.CTA.VEN<I.VAR>  = 0
    NEXT I.VAR

*
*
RETURN
*
*
* ---------
* Allows to fill the Y.MORA.CTA.VEN array
GET.DUE.DATES:
* ---------
*
*
    BILL.REFERENCE = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID,I.VAR>
    CALL AA.GET.BILL.DETAILS(AA.ID, BILL.REFERENCE, BILL.DETAILS, RET.ERROR)
    Y.SETTLED.DATE = ""
    Y.DUE.DATE = ""
    Y.DUE.DATE = BILL.DETAILS<AA.BD.PAYMENT.DATE>
    LOCATE "SETTLED" IN BILL.DETAILS<AA.BD.BILL.STATUS,1> SETTING Y.POS THEN
        Y.SETTLED.DATE = BILL.DETAILS<AA.BD.BILL.STATUS,Y.POS>
    END
    LOCATE "DUE" IN BILL.DETAILS<AA.BD.BILL.STATUS,1> SETTING Y.POS THEN
        Y.DUE.DATE = BILL.DETAILS<AA.BD.BILL.STATUS,Y.POS>
    END
    FOR I.BILL.HIST = 1 TO 11
        Y.IS.DUE  = Y.DUE.DATE LT Y.MORA.DATES<I.VAR>
        Y.IS.UNPAID = Y.SETTLED.DATE EQ "" OR Y.SETTLED.DATE LT Y.MORA.DATES<I.VAR>
        IF Y.IS.DUE AND Y.IS.UNPAID THEN          ;* It should be paid before the last day of the month
            Y.MORA.CTA.VEN<I.VAR> = Y.MORA.CTA.VEN<I.VAR> + 1
        END
    NEXT I.BILL.HIST

RETURN
* ---------
* Allows to get amount Info
GET.BILL.AMOUNT.DETAILS:
* ---------
    Y.BILL.DET.TOT=DCOUNT(R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE,I.VAR,1>,@SM)
    Y.BILL.DET.CNT=1
    LOOP
    WHILE Y.BILL.DET.CNT LE Y.BILL.DET.TOT
        IF R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE,I.VAR,Y.BILL.DET.CNT> EQ 'PAYMENT' AND R.AA.ACCOUNT.DETAILS<AA.AD.SET.STATUS,I.VAR,Y.BILL.DET.CNT> EQ 'UNPAID' THEN
            BILL.REFERENCE = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID,I.VAR,Y.BILL.DET.CNT>
            CALL AA.GET.BILL.DETAILS(AA.ID, BILL.REFERENCE, BILL.DETAILS, RET.ERROR)
            IF SUM(BILL.DETAILS<AA.BD.OS.PROP.AMOUNT>) NE 0 THEN
                Y.TMPCREDITOCUOTASVENCIDAS += 1
                Y.TMPCREDITOMONTOMOROSO += SUM(BILL.DETAILS<AA.BD.OS.PROP.AMOUNT>)
            END
*        LOCATE Y.ST.STATUS.EXP IN BILL.DETAILS<AA.BD.SET.STATUS,1> SETTING Y.POS THEN
* Just take the more due date
            IF Y.PREV.DATE EQ '' THEN
*           Y.PREV.DATE =  BILL.DETAILS<AA.BD.AGING.ST.CHG.DT,Y.POS>
                Y.PREV.DATE = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.DATE,I.VAR,1>
            END
*END
        END
        IF R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE,I.VAR,Y.BILL.DET.CNT> EQ 'PAYMENT' AND R.AA.ACCOUNT.DETAILS<AA.AD.BILL.STATUS,I.VAR,Y.BILL.DET.CNT> EQ 'SETTLED' THEN
            BILL.REFERENCE = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID,I.VAR,Y.BILL.DET.CNT>
            CALL AA.GET.BILL.DETAILS(AA.ID, BILL.REFERENCE, BILL.DETAILS, RET.ERROR)

            IF SUM(BILL.DETAILS<AA.BD.OS.PROP.AMOUNT>) EQ 0 THEN
                Y.TMPCREDITOCUOTASPAGADAS += 1
            END
        END

        Y.BILL.DET.CNT += 1
    REPEAT
RETURN
*
*-----------------------
END
