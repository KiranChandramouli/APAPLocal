* @ValidationCode : MjotNTY0ODkyNDc6Q3AxMjUyOjE2ODIzMzE1NjU0NjY6SVRTUzotMTotMTo4Nzc6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:49:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 877
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.AZ.INT.PAGO.30DIAS
*
* Description: The report to show the accred interest greater than 30 days.
* Dev By : V.P.Ashokkumar
*-----------------------------------------------------*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 21.04.2023       Conversion Tool       R22            Auto Conversion     - $INCLUDE T24.BP TO $INSERT, $INCLUDE TAM.BP TO $INSERT, = YCNT + TO +=, -- TO -= 1
* 21.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------


    $INSERT I_COMMON                ;** R22 Auto conversion - $INCLUDE T24.BP TO $INSERT
    $INSERT I_EQUATE                ;** R22 Auto conversion - $INCLUDE T24.BP TO $INSERT
    $INSERT I_F.AZ.ACCOUNT          ;** R22 Auto conversion - $INCLUDE T24.BP TO $INSERT
    $INSERT I_F.ACCR.ACCT.CR        ;** R22 Auto conversion - $INCLUDE T24.BP TO $INSERT
    $INSERT I_F.REDO.H.REPORTS.PARAM      ;** R22 Auto conversion - $INCLUDE TAM.BP TO $INSERT


    GOSUB INIT
    GOSUB READ.PARAM
    GOSUB PROCESS
RETURN

INIT:
*****
    YFIN.ARRY = ''
    YPARAM.ID = 'REDO.OPER.ENQ'
    FN.ACCR.ACCT.CR = 'F.ACCR.ACCT.CR'; F.ACCR.ACCT.CR = ''
    CALL OPF(FN.ACCR.ACCT.CR,F.ACCR.ACCT.CR)
    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'; F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'; F.REDO.H.REPORTS.PARAM = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
RETURN

READ.PARAM:
***********
    ERR.REDO.H.REPORTS.PARAM = ''; R.REDO.H.REPORTS.PARAM = ''
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,YPARAM.ID,R.REDO.H.REPORTS.PARAM,ERR.REDO.H.REPORTS.PARAM)
    IF R.REDO.H.REPORTS.PARAM THEN
        FN.CHK.DIR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
    END

    F.CHK.DIR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)
    Y.FINAL.OUT.FILE.NAME = "AZ.TASAS.PAGO.MIA30.DIAS.txt"
    R.FIL = ''; READ.FIL.ERR = ''
    CALL F.READ(FN.CHK.DIR,Y.FINAL.OUT.FILE.NAME,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR,Y.FINAL.OUT.FILE.NAME
    END
RETURN

PROCESS:
********
    YFIN.ARRY = "No. Certificado,Fecha Corte,Cant. Dias,Monto Ints. Acumulados,Sucursal"
    SEL.AZ = ''; SEL.REC = ''; SEL.LIST = ''; SEL.ERR = ''
    SEL.AZ = "SELECT ":FN.AZ.ACCOUNT
    CALL EB.READLIST(SEL.AZ,SEL.REC,'',SEL.LIST,SEL.ERR)
    LOOP
        REMOVE ACCR.ID FROM SEL.REC SETTING SEL.POSN
    WHILE ACCR.ID:SEL.POSN

        AZ.ACCT.ERR = ''; R.AZ.ACCOUNT = ''; INT.DATE.LST = ''; YFLD4 = ''; YNO.OF.DAY = ''
        ERR.ACCR.ACCT.CR = ''; R.ACCR.ACCT.CR = ''; YINT.CNT = 0; YCNT = 0
        CALL F.READ(FN.ACCR.ACCT.CR,ACCR.ID,R.ACCR.ACCT.CR,F.ACCR.ACCT.CR,ERR.ACCR.ACCT.CR)

        YNO.OF.DAY = SUM(R.ACCR.ACCT.CR<IC.ACRCR.CR.NO.OF.DAYS>)
        IF (YNO.OF.DAY EQ '' OR YNO.OF.DAY LE 30) THEN              ;** R22 Auto conversion
            CONTINUE                                                ;** R22 Auto conversion
        END                                                         ;** R22 Auto conversion

        CALL F.READ(FN.AZ.ACCOUNT,ACCR.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ACCT.ERR)
        YFLD4 = R.AZ.ACCOUNT<AZ.CO.CODE>
        INT.DATE.LST = R.ACCR.ACCT.CR<IC.ACRCR.CR.INT.DATE>
        YINT.CNT = DCOUNT(INT.DATE.LST,@VM)

        LOOP
        UNTIL YINT.CNT EQ 0
            YCNT += 1                                                ;** R22 Auto conversion - = YCNT + TO +=
            YFLD1 = ''; YFLD2 = ''; YFLD3 = ''
            YFLD1 = R.ACCR.ACCT.CR<IC.ACRCR.CR.INT.DATE,YCNT>
            YFLD2 = R.ACCR.ACCT.CR<IC.ACRCR.CR.NO.OF.DAYS,YCNT>
            YFLD3 = R.ACCR.ACCT.CR<IC.ACRCR.CR.INT.AMT,YCNT>

            YFIN.ARRY<-1> = ACCR.ID:',':YFLD1:',':YFLD2:',':YFLD3:',':YFLD4
            YINT.CNT -= 1                       ;** R22 Auto conversion - -- TO -= 1
        REPEAT
    REPEAT

    WRITE YFIN.ARRY ON F.CHK.DIR, Y.FINAL.OUT.FILE.NAME ON ERROR
        Y.ERR.MSG = "Unable to Write ":Y.FINAL.OUT.FILE.NAME
        RETURN
    END
RETURN

END
