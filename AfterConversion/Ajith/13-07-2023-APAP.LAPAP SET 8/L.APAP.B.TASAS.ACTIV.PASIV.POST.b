$PACKAGE APAP.LAPAP
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*13-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     TAM.BP is Removed , FM to @FM,++ to +=,I to I.VAR
*13-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE L.APAP.B.TASAS.ACTIV.PASIV.POST
*
* Client Name   : APAP
* Develop By    : Ashokkumar
* Description   : The routine to generate the Activasa and Pasivas report AR010.
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.REDO.H.REPORTS.PARAM ;*R22 Auto code conversion
    $INSERT I_L.APAP.B.TASAS.ACTIV.PASIV.COMMON

    SLEEP 30
    GOSUB INIT
    GOSUB PROCESS.SUB
    GOSUB PROCESS
RETURN

INIT:
*****
    FN.DR.REG.PASIVAS.ACTIV = 'F.DR.REG.PASIVAS.ACTIV'; F.DR.REG.PASIVAS.ACTIV = ''
    CALL OPF(FN.DR.REG.PASIVAS.ACTIV,F.DR.REG.PASIVAS.ACTIV)
    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'; F.REDO.H.REPORTS.PARAM = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
    REDO.H.REPORTS.PARAM.ID = 'REDO.TASAS.PASIV'
    ERR.REDO.H.REPORTS.PARAM = ''; R.REDO.H.REPORTS.PARAM = ''
    CALL F.READ(FN.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ID,R.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM,ERR.REDO.H.REPORTS.PARAM)
    FN.CHK.DIR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
    YOUT.FILENAME =R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
    Y.LST.DTE = R.DATES(EB.DAT.LAST.WORKING.DAY)
    YLST.DTE = Y.LST.DTE[7,2]:'/':Y.LST.DTE[5,2]:'/':Y.LST.DTE[1,4]
    YLSTDTE = Y.LST.DTE[7,2]:Y.LST.DTE[5,2]:Y.LST.DTE[1,4]

    F.CHK.DIR = ''
    OPEN FN.CHK.DIR TO F.CHK.DIR ELSE
        CALL FATAL.ERROR("UNABLE TO OPEN ":F.CHK.DIR)
    END
    YEXTRACT.FILENAME = YOUT.FILENAME:YLSTDTE:'.txt'
    R.FIL = '';    FIL.ERR = ''; R.FILE.DATA = ''
    CALL F.READ(FN.CHK.DIR,YEXTRACT.FILENAME,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR,YEXTRACT.FILENAME
    END
RETURN

PROCESS:
********
    CRT "PROCESS 3"
    SEL.ERR = ''; SEL.LST = ''; SEL.REC = ''; SEL.CMD = ''
    SEL.CMD = "SSELECT ":FN.DR.REG.PASIVAS.ACTIV:" WITH @ID UNLIKE 225..."
    CALL EB.READLIST(SEL.CMD,SEL.REC,'',SEL.LST,SEL.ERR)
    YCNT = 1; YCOUNT.FLAG = 0; YFLD2.TOT = 0; YFLD1.TOT = 0; YFLD3.TOT = 0
    LOOP
        REMOVE SEL.ID FROM SEL.REC SETTING SL.POSN
    WHILE SEL.ID:SL.POSN
        CRT SEL.ID
        ERR.DR.REG.PASIVAS.ACTIV = ''; R.DR.REG.PASIVAS.ACTIV = ''
        CALL F.READ(FN.DR.REG.PASIVAS.ACTIV,SEL.ID,R.DR.REG.PASIVAS.ACTIV,F.DR.REG.PASIVAS.ACTIV,ERR.DR.REG.PASIVAS.ACTIV)

        YCHK.VAL = FIELD(SEL.ID,'-',1)
        IF YCNT EQ 1 THEN
            YGRP.ARRY<-1> = R.DR.REG.PASIVAS.ACTIV
            YFLD1.TOT = FIELD(R.DR.REG.PASIVAS.ACTIV,'|',14)
            YFLD2.TOT = FIELD(R.DR.REG.PASIVAS.ACTIV,'|',17)
            YFLD3.TOT = FIELD(R.DR.REG.PASIVAS.ACTIV,'|',23)
            YCOUNT.FLAG += 1; YCOUNT.FLAG1 += 1
            YCHK.VAL.OLD = YCHK.VAL
            YCNT += 1 ;*R22 Auto code conversion
            CONTINUE
        END

        IF YCHK.VAL EQ YCHK.VAL.OLD THEN
            YGRP.ARRY<-1> = R.DR.REG.PASIVAS.ACTIV
            YFLD1.TOT += FIELD(R.DR.REG.PASIVAS.ACTIV,'|',14)
            YFLD2.TOT += FIELD(R.DR.REG.PASIVAS.ACTIV,'|',17)
            YFLD3.TOT += FIELD(R.DR.REG.PASIVAS.ACTIV,'|',23)
            YCOUNT.FLAG += 1
        END ELSE
            GOSUB GET.ARRAY.VALUE
            YGRP.ARRY<-1> = R.DR.REG.PASIVAS.ACTIV
            YCOUNT.FLAG = 0; YFLD1.TOT = 0; YFLD2.TOT = 0; YFLD3.TOT = 0
            YFLD1.TOT = FIELD(R.DR.REG.PASIVAS.ACTIV,'|',14)
            YFLD2.TOT = FIELD(R.DR.REG.PASIVAS.ACTIV,'|',17)
            YFLD3.TOT = FIELD(R.DR.REG.PASIVAS.ACTIV,'|',23)
            YCOUNT.FLAG += 1
        END

        IF YCNT EQ SEL.LST THEN
            GOSUB GET.ARRAY.VALUE
        END
        YCHK.VAL.OLD = YCHK.VAL
        YCNT += 1 ;*R22 Auto code conversion
    REPEAT
    CRLF = CHARX(013):CHARX(010)
    CHANGE @FM TO CRLF IN YGRP.ARRY ;*R22 Auto code conversion
    CALL F.WRITE(FN.CHK.DIR,YEXTRACT.FILENAME,YGRP.ARRY)
RETURN

PROCESS.SUB:
************
    CRT "PROCESS 1"
    SEL.ERR = ''; SEL.LST = ''; SEL.REC = ''; SEL.CMD = ''
    SEL.CMD = "SSELECT ":FN.DR.REG.PASIVAS.ACTIV:" WITH @ID LIKE 225..."
    CALL EB.READLIST(SEL.CMD,SEL.REC,'',SEL.LST,SEL.ERR)
    YCOUNT.FLAG = 0; YSEQ.FLAG = 1; YFLD2.TOT = 0; YFLD1.TOT = 0; YAC.CNT = 0
    YFLD3.TOT = 0; YINT.ARRY = ''; YAC.FLG.CNT = ''; YAC.BAL.ARRY = ''; YAC.INT.ARRY = ''
    LOOP
        REMOVE SEL.ID FROM SEL.REC SETTING SL.POSN
    WHILE SEL.ID:SL.POSN
        CRT SEL.ID
        ERR.DR.REG.PASIVAS.ACTIV = ''; R.DR.REG.PASIVAS.ACTIV = ''
        CALL F.READ(FN.DR.REG.PASIVAS.ACTIV,SEL.ID,R.DR.REG.PASIVAS.ACTIV,F.DR.REG.PASIVAS.ACTIV,ERR.DR.REG.PASIVAS.ACTIV)

        YCHK.VAL = FIELD(SEL.ID,'-',1)
        IF SEL.ID[1,10] NE '225ACDUMMY' THEN
            YFLD2.INT = ''; YFLD2.INT = FIELD(R.DR.REG.PASIVAS.ACTIV,'|',17)

            LOCATE YFLD2.INT IN YAC.INT.ARRY<1> SETTING YPONS.AC THEN
                YAC.BAL.ARRY<YPONS.AC> += FIELD(R.DR.REG.PASIVAS.ACTIV,'|',14)
                YAC.FLG.CNT<YPONS.AC> += 1
            END ELSE
                YAC.BAL.ARRY<-1> = FIELD(R.DR.REG.PASIVAS.ACTIV,'|',14)
                YAC.INT.ARRY<-1> = YFLD2.INT
                YAC.FLG.CNT<-1> = '1'
            END

            LOCATE YFLD2.INT IN YINT.ARRY<1> SETTING YPONS THEN
                YBAL.ARRY<YPONS> += FIELD(R.DR.REG.PASIVAS.ACTIV,'|',14)
                YAC.CNT += 1
            END ELSE
                YBAL.ARRY<-1> = FIELD(R.DR.REG.PASIVAS.ACTIV,'|',14)
                YINT.ARRY<-1> = YFLD2.INT
                YAC.CNT += 1
            END
        END ELSE

            YFLD2.INT = FIELD(R.DR.REG.PASIVAS.ACTIV,'|',17)
            LOCATE YFLD2.INT IN YINT.ARRY<1> SETTING YPONS THEN
                YBAL.ARRY<YPONS> += FIELD(R.DR.REG.PASIVAS.ACTIV,'|',14)
                YAC.CNT += 1 ;*R22 Auto code conversion
            END ELSE
                YBAL.ARRY<-1> = FIELD(R.DR.REG.PASIVAS.ACTIV,'|',14)
                YINT.ARRY<-1> = YFLD2.INT
                YAC.CNT += 1 ;*R22 Auto code conversion
            END
        END
    REPEAT
    CRT "PROCESS 2"
    GOSUB GET.ARRAY.VALUE.SUB
    GOSUB GET.AC.ARRY
RETURN

GET.ARRAY.VALUE:
****************
    APPL = ''; APPL = YCHK.VAL.OLD[1,1]
    SECT = ''; SECT = YCHK.VAL.OLD[2,2]
    YANG = ''; YANG = YFLD2.TOT / YCOUNT.FLAG
    YFLD3.VAL = ''; YFLD3.VAL = YFLD3.TOT / YCOUNT.FLAG
    YGRP.ARRY<-1> = FMT(YSEQ.FLAG,'L#25'):"|":FMT(YLST.DTE,'L#10'):"|":FMT('B','L#2'):"|":FMT(APPL,'L%1'):"|":FMT(SECT,'R%2'):"|":FMT('0','R%2'):"|":FMT('NA','L#3'):"|":FMT('NA','L#100'):"|":FMT('NA','L#15'):"|":FMT('1','R%1'):"|":FMT(YLST.DTE,'L#10'):"|":FMT(YLST.DTE,'L#10'):"|":FMT('DOP','L#3'):"|":FMT(YFLD1.TOT,'R2%17'):"|":FMT('0','R%6'):"|":FMT('0','R%2'):"|":FMT(YANG,'R2%5'):"|":FMT('N','L#2'):"|":FMT('NA','L#2'):"|":FMT('NA','L#2'):"|1|0|":FMT(YFLD3.VAL,'R2%5'):"|":FMT('1','R%2'):"|":FMT('1','R%2'):"|":FMT('NA','L#100'):"|":FMT('0','R2%10'):"|":FMT('0','R2%17'):"|":FMT('0','R%1'):"|":FMT('0','R%1'):"|":FMT(YCOUNT.FLAG,'R%8'):"|":FMT('NA','L#2'):"|":FMT('1','R%3'):"|"
    YSEQ.FLAG += 1
RETURN

GET.ARRAY.VALUE.SUB:
*********************
    YAC.BAL.ARRY.TOT = 0; YTEMP.AMT.TOT = ''; YAC.MCNT = 0; YFLD1.TOT = ''; YANG = ''
    YAC.BAL.CNT = DCOUNT(YAC.BAL.ARRY,@FM)
    FOR I.VAR = 1 TO YAC.BAL.CNT
        YAC.MCNT += 1
        YFLD1.TOT = YAC.BAL.ARRY<YAC.MCNT>
        YANG = YAC.INT.ARRY<YAC.MCNT>
        YCOUNT.FLAG = YAC.FLG.CNT<YAC.MCNT>
        YGRP.ARRY<-1> = FMT(YSEQ.FLAG,'L#25'):"|":FMT(YLST.DTE,'L#10'):"|":FMT('N','L#2'):"|":FMT('2','L%1'):"|":FMT('25','R%2'):"|":FMT('0','R%2'):"|":FMT('NA','L#3'):"|":FMT('NA','L#100'):"|":FMT('NA','L#15'):"|":FMT('1','R%1'):"|":FMT(YLST.DTE,'L#10'):"|":FMT(YLST.DTE,'L#10'):"|":FMT('DOP','L#3'):"|":FMT(YFLD1.TOT,'R2%17'):"|":FMT('0','R%6'):"|":FMT('0','R%2'):"|":FMT(YANG,'R2%5'):"|":FMT('N','L#2'):"|":FMT('NA','L#2'):"|":FMT('NA','L#2'):"|1|0|":FMT('0','R2%5'):"|":FMT('1','R%2'):"|":FMT('1','R%2'):"|":FMT('NA','L#100'):"|":FMT('0','R2%10'):"|":FMT('0','R2%17'):"|":FMT('0','R%1'):"|":FMT('0','R%1'):"|":FMT(YCOUNT.FLAG,'R%8'):"|":FMT('NA','L#2'):"|":FMT('1','R%3'):"|"
        YSEQ.FLAG += 1
    NEXT I.VAR
    YCOUNT.FLAG = ''; YANG = ''; YFLD1.TOT = ''
RETURN

GET.AC.ARRY:
************
    YBAL.ARRY.TOT = 0; YTEMP.AMT.TOT = ''; YMCNT = 0
    YBAL.CNT = DCOUNT(YBAL.ARRY,@FM)
    FOR I.VAR = 1 TO YBAL.CNT
        YMCNT += 1 ;*R22 Auto code conversion
        YTEMP.AMT = (YBAL.ARRY<YMCNT> * YINT.ARRY<YMCNT>) / 100
        YTEMP.AMT.TOT += YTEMP.AMT
        YBAL.ARRY.TOT += YBAL.ARRY<YMCNT>

    NEXT I.VAR
    YANG = (YTEMP.AMT.TOT / YBAL.ARRY.TOT) * 100
    YGRP.ARRY<-1> = FMT(YSEQ.FLAG,'L#25'):"|":FMT(YLST.DTE,'L#10'):"|":FMT('B','L#2'):"|":FMT('2','L%1'):"|":FMT('25','R%2'):"|":FMT('0','R%2'):"|":FMT('NA','L#3'):"|":FMT('NA','L#100'):"|":FMT('NA','L#15'):"|":FMT('1','R%1'):"|":FMT(YLST.DTE,'L#10'):"|":FMT(YLST.DTE,'L#10'):"|":FMT('DOP','L#3'):"|":FMT(YBAL.ARRY.TOT,'R2%17'):"|":FMT('0','R%6'):"|":FMT('0','R%2'):"|":FMT(YANG,'R2%5'):"|":FMT('N','L#2'):"|":FMT('NA','L#2'):"|":FMT('NA','L#2'):"|1|0|":FMT('0','R2%5'):"|":FMT('1','R%2'):"|":FMT('1','R%2'):"|":FMT('NA','L#100'):"|":FMT('0','R2%10'):"|":FMT('0','R2%17'):"|":FMT('0','R%1'):"|":FMT('0','R%1'):"|":FMT(YAC.CNT,'R%8'):"|":FMT('NA','L#2'):"|":FMT('1','R%3'):"|"
    YSEQ.FLAG += 1
RETURN

END
