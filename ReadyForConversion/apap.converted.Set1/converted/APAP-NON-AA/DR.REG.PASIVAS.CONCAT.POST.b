SUBROUTINE DR.REG.PASIVAS.CONCAT.POST
*----------------------------------------------------------------------------------------------------------------------------------
*
* Description  : This routine will get the details from work file and writes into text file.
*-------------------------------------------------------------------------
* Date         Author               Description
* ==========   ================     ============
* 25-Jul-2014  Ashokkumar.V.P       PACS00305233:- Fixed to display the value with proper format &
*                                    added SubTotal, Total in all the section.
* 09-Oct-2014  Ashokkumar.V.P       PACS00305233:- Changed the report format to new layout
* 16-Apr-2015  Ashokkumar.V.P       PACS00305233:- Changed for performance issue
*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BATCH
    $INSERT I_F.DATES
    $INSERT I_F.DR.REG.PASIVAS.PARAM
    $INSERT I_F.DR.REG.PASIVAS.GROUP

    GOSUB OPEN.FILES
    GOSUB PROCESS.PARA
RETURN

OPEN.FILES:
***********
    DR.REG.PASIVAS.PARAM.ERR = ''; R.DR.REG.PASIVAS.PARAM = ''; F.CHK.DIR = ''
    FN.DR.REG.PASIVAS.PARAM = 'F.DR.REG.PASIVAS.PARAM'; F.DR.REG.PASIVAS.PARAM = ''
    FN.DR.REG.PASIVAS.WORKFILE = "F.DR.REG.PASIVAS.GROUP"; F.DR.REG.PASIVAS.WORKFILE = ""

    CALL OPF(FN.DR.REG.PASIVAS.PARAM,F.DR.REG.PASIVAS.PARAM)
    CALL OPF(FN.DR.REG.PASIVAS.WORKFILE, F.DR.REG.PASIVAS.WORKFILE)
    CALL CACHE.READ(FN.DR.REG.PASIVAS.PARAM,'SYSTEM',R.DR.REG.PASIVAS.PARAM,DR.REG.PASIVAS.PARAM.ERR)
    FN.CHK.DIR = R.DR.REG.PASIVAS.PARAM<DR.PASIVAS.PARAM.OUT.PATH>
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)
    EXTRACT.FILE.ID = R.DR.REG.PASIVAS.PARAM<DR.PASIVAS.PARAM.FILE.NAME,4>:'.txt'
    R.FIL = ''; FIL.ERR = ''
    CALL F.READ(FN.CHK.DIR,EXTRACT.FILE.ID,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    IF R.FIL THEN
        CALL F.DELETE(FN.CHK.DIR,EXTRACT.FILE.ID)
    END
RETURN

PROCESS.PARA:
*************
    GOSUB PROCESS.HEADER
    ID.LIST1 = ''; ID.LIST2 = ''; ID.LIST9 = ''; ID.LIST7 = ''; ID.LIST3 = ''
    ID.LIST4 = ''; ID.LIST10 = ''; ID.LIST5 = ''; ID.LIST6 = ''; ID.LIST11 = ''; ID.LIST8 = ''
    SEL.CMD1 = "SELECT ":FN.DR.REG.PASIVAS.WORKFILE
    CALL EB.READLIST(SEL.CMD1, ID.LIST.GRP, "", ID.CNT.GRP, ERR.SEL1)
    LOOP
        REMOVE WORK.ID FROM ID.LIST.GRP SETTING ID.POSN
    WHILE WORK.ID:ID.POSN
        BEGIN CASE
            CASE WORK.ID[1,6] EQ 'GROUP8'
                ID.LIST1<-1> = WORK.ID
            CASE WORK.ID[1,6] EQ 'GROUP9'
                ID.LIST2<-1> = WORK.ID
            CASE WORK.ID[1,7] EQ 'GROUP10'
                ID.LIST3<-1> = WORK.ID
            CASE WORK.ID[1,7] EQ 'GROUP11'
                ID.LIST4<-1> = WORK.ID
            CASE WORK.ID[1,7] EQ 'GROUP12'
                ID.LIST5<-1> = WORK.ID
            CASE WORK.ID[1,7] EQ 'GROUP13'
                ID.LIST6<-1> = WORK.ID
            CASE WORK.ID[1,7] EQ 'GROUP14'
                ID.LIST7<-1> = WORK.ID
            CASE WORK.ID[1,7] EQ 'GROUP15'
                ID.LIST8<-1> = WORK.ID
            CASE WORK.ID[1,7] EQ 'GROUP16'
                ID.LIST9<-1> = WORK.ID
            CASE WORK.ID[1,7] EQ 'GROUP17'
                ID.LIST10<-1> = WORK.ID
            CASE WORK.ID[1,7] EQ 'GROUP18'
                ID.LIST11<-1> = WORK.ID
        END CASE
    REPEAT

    IF ID.LIST1 THEN
        GOSUB WRITE.BODY.PARA1
    END
    IF ID.LIST2 THEN
        GOSUB WRITE.BODY.PARA2
    END
    IF ID.LIST3 THEN
        GOSUB WRITE.BODY.PARA3
    END
    IF ID.LIST4 THEN
        GOSUB WRITE.BODY.PARA4
    END
    IF ID.LIST5 THEN
        GOSUB WRITE.BODY.PARA5
    END
    IF ID.LIST6 THEN
        GOSUB WRITE.BODY.PARA6
    END
    IF ID.LIST7 THEN
        GOSUB WRITE.BODY.PARA7
    END
    IF ID.LIST8 THEN
        GOSUB WRITE.BODY.PARA8
    END
    IF ID.LIST9 THEN
        REP.LINE0 = FMT(R.DR.REG.PASIVAS.PARAM<DR.PASIVAS.PARAM.GRP.REP.NAME,2>,'65L')
        GOSUB WRITE.BODY.PARA9
    END
    IF ID.LIST10 THEN
        REP.LINE0 = FMT(R.DR.REG.PASIVAS.PARAM<DR.PASIVAS.PARAM.GRP.REP.NAME,3>,'65L')
        GOSUB WRITE.BODY.PARA10
    END
    IF ID.LIST11 THEN
        REP.LINE0 = FMT(R.DR.REG.PASIVAS.PARAM<DR.PASIVAS.PARAM.GRP.REP.NAME,1>,'65L')
        GOSUB WRITE.BODY.PARA11
    END
    CALL F.WRITE(FN.CHK.DIR,EXTRACT.FILE.ID,RETURN.ARR)
RETURN

PROCESS.HEADER:
***************
    RETURN.ARR = ''
    RETURN.ARR<-1> = R.DR.REG.PASIVAS.PARAM<DR.PASIVAS.PARAM.FILE.NAME,1>
    LAST.WORK.VAL = R.DATES(EB.DAT.LAST.WORKING.DAY)
    LAST.DATE = LAST.WORK.VAL[7,2]:"/":LAST.WORK.VAL[5,2]:"/":LAST.WORK.VAL[1,4]
    RETURN.ARR<-1> = R.DR.REG.PASIVAS.PARAM<DR.PASIVAS.PARAM.FILE.NAME,2>
    RETURN.ARR<-1> = R.DR.REG.PASIVAS.PARAM<DR.PASIVAS.PARAM.FILE.NAME,3>:": ":LAST.DATE
    BODY.HEAD1<-1> = FMT('Instrumento','65L'):FMT('Plazo','26L'):FMT('Cantidad','10R'):FMT('Tasa(%Anual)','14R'):FMT('Monto','18R')
    RETURN.ARR<-1> = BODY.HEAD1
RETURN

WRITE.BODY.PARA11:
******************
    CNT.LOAN = ''; TOT.AMT = ''
    LOOP
        REMOVE REC.ID11 FROM ID.LIST11 SETTING ID.POS11
    WHILE REC.ID11:ID.POS11
        YPASIVAS.ID = REC.ID11
        GOSUB READ.PASIVAS.WORK
        REP.LINE1 = ''; YRATE.VAL = ''
        YRATE.VAL = FIELD(REC.ID11,'-',2)
        GOSUB REP.LINE.ARRY
    REPEAT
    IF CNT.LOAN OR TOT.AMT THEN
        GOSUB PARA.WRIT.ARRY
    END
RETURN

REP.LINE.ARRY:
**************
    IF R.REC1 THEN
        CNT.LOAN += R.REC1<DR.PAS.GRP.SUB1.LOANS>
        TOT.AMT += R.REC1<DR.PAS.GRP.SUB1.AMT>
        REP.LINE.SUBAR<-1> = FMT("",'65L'):FMT("",'26L'):FMT(R.REC1<DR.PAS.GRP.SUB1.LOANS>,'10R'):FMT(YRATE.VAL,'R6#14'):FMT(R.REC1<DR.PAS.GRP.SUB1.AMT>,'R2,#18')
    END
RETURN

PARA.WRIT.ARRY:
***************
    RETURN.ARR<-1> = REP.LINE0:@FM:REP.LINE.SUBAR:@FM:FMT('SubTotal:','65L'):FMT('','26L'):FMT(CNT.LOAN,'10R'):FMT('','14R'):FMT(TOT.AMT,'R2,#18')
    RETURN.ARR<-1> = FMT('Total:','65L'):FMT('','26L'):FMT(CNT.LOAN,'10R'):FMT('','14R'):FMT(TOT.AMT,'R2,#18')
    REP.LINE.SUBAR = ''; REP.LINE0 = ''
RETURN

WRITE.BODY.PARA9:
******************
    ID.LIST11 = ID.LIST9
    GOSUB WRITE.BODY.PARA11
RETURN

WRITE.BODY.PARA10:
******************
    ID.LIST11 = ID.LIST10
    GOSUB WRITE.BODY.PARA11
RETURN

INIT.VAR:
*********
    CNT.LOAN = ''; CNT.LOAN.PR1 = ''; CNT.LOAN.PR2 = ''; CNT.LOAN.PR3 = ''; CNT.LOAN.PR4 = ''; CNT.LOAN.PR5 = ''; CNT.LOAN.PR6 = ''
    TOT.AMT = ''; TOT.AMT.PR1 = ''; TOT.AMT.PR2 = ''; TOT.AMT.PR3 = ''; TOT.AMT.PR4 = ''; TOT.AMT.PR5 = ''; TOT.AMT.PR6 = ''; REC.ID1 = ''
    RETURN.ARR.PR1 = ''; RETURN.ARR.PR2 = ''; RETURN.ARR.PR3 = ''; RETURN.ARR.PR4 = ''; RETURN.ARR.PR5 = ''; RETURN.ARR.PR6 = ''
RETURN

WRITE.BODY.PARA1:
****************
    REP.LINE0 = FMT(R.DR.REG.PASIVAS.PARAM<DR.PASIVAS.PARAM.GRP.REP.NAME,4>,'65L')
    RETURN.ARR<-1> = REP.LINE0
    GOSUB INIT.VAR
    LOOP
        REMOVE REC.ID1 FROM ID.LIST1 SETTING ID.POS1
    WHILE REC.ID1:ID.POS1
        YPASIVAS.ID = REC.ID1
        GOSUB READ.PASIVAS.WORK
        GOSUB BODY.PARA1.CASE
    REPEAT
    GOSUB RETURN.ARRY.WRITE
RETURN

BODY.PARA1.CASE:
****************
    REP.LINE1.1 = ''; REP.LINE1.2 = ''; REP.LINE1.3 = ''; REP.LINE1.4 = ''; REP.LINE1.5 = ''; REP.LINE1.6 = ''; REP.LINE1.7 = ''; REP.LINE1.8 = ''
    IF R.REC1<DR.PAS.GRP.SUB1.LOANS> AND R.REC1<DR.PAS.GRP.SUB1.AMT> THEN
        CNT.LOAN.PR1 += R.REC1<DR.PAS.GRP.SUB1.LOANS>
        TOT.AMT.PR1 += R.REC1<DR.PAS.GRP.SUB1.AMT>
        REP.LINE1.1 = FMT("",'65L'):FMT(R.DR.REG.PASIVAS.PARAM<DR.PASIVAS.PARAM.GRP.REP.RANGE,1>,'26L'):FMT(R.REC1<DR.PAS.GRP.SUB1.LOANS>,'10R'):FMT(FIELD(REC.ID1,'-',2),'R6#14'):FMT(R.REC1<DR.PAS.GRP.SUB1.AMT>,'R2,#18')
        GOSUB ARRY.RANGE1.L1
    END
    IF R.REC1<DR.PAS.GRP.SUB2.LOANS> AND R.REC1<DR.PAS.GRP.SUB2.AMT> THEN
        CNT.LOAN.PR2 += R.REC1<DR.PAS.GRP.SUB2.LOANS>
        TOT.AMT.PR2 += R.REC1<DR.PAS.GRP.SUB2.AMT>
        REP.LINE1.2 = FMT("",'65L'):FMT(R.DR.REG.PASIVAS.PARAM<DR.PASIVAS.PARAM.GRP.REP.RANGE,2>,'26L'):FMT(R.REC1<DR.PAS.GRP.SUB2.LOANS>,'10R'):FMT(FIELD(REC.ID1,'-',2),'R6#14'):FMT(R.REC1<DR.PAS.GRP.SUB2.AMT>,'R2,#18')
        GOSUB ARRY.RANGE2.L1
    END
    IF R.REC1<DR.PAS.GRP.SUB3.LOANS> AND R.REC1<DR.PAS.GRP.SUB3.AMT> THEN
        CNT.LOAN.PR3 += R.REC1<DR.PAS.GRP.SUB3.LOANS>
        TOT.AMT.PR3 += R.REC1<DR.PAS.GRP.SUB3.AMT>
        REP.LINE1.3 = FMT("",'65L'):FMT(R.DR.REG.PASIVAS.PARAM<DR.PASIVAS.PARAM.GRP.REP.RANGE,3>,'26L'):FMT(R.REC1<DR.PAS.GRP.SUB3.LOANS>,'10R'):FMT(FIELD(REC.ID1,'-',2),'R6#14'):FMT(R.REC1<DR.PAS.GRP.SUB3.AMT>,'R2,#18')
        GOSUB ARRY.RANGE3.L1
    END
    IF R.REC1<DR.PAS.GRP.SUB4.LOANS> AND R.REC1<DR.PAS.GRP.SUB4.AMT> THEN
        CNT.LOAN.PR4 += R.REC1<DR.PAS.GRP.SUB4.LOANS>
        TOT.AMT.PR4 += R.REC1<DR.PAS.GRP.SUB4.AMT>
        REP.LINE1.4 = FMT("",'65L'):FMT(R.DR.REG.PASIVAS.PARAM<DR.PASIVAS.PARAM.GRP.REP.RANGE,4>,'26L'):FMT(R.REC1<DR.PAS.GRP.SUB4.LOANS>,'10R'):FMT(FIELD(REC.ID1,'-',2),'R6#14'):FMT(R.REC1<DR.PAS.GRP.SUB4.AMT>,'R2,#18')
        GOSUB ARRY.RANGE4.L1
    END
    IF R.REC1<DR.PAS.GRP.SUB5.LOANS> AND R.REC1<DR.PAS.GRP.SUB5.AMT> THEN
        CNT.LOAN.PR5 += R.REC1<DR.PAS.GRP.SUB5.LOANS>
        TOT.AMT.PR5 += R.REC1<DR.PAS.GRP.SUB5.AMT>
        REP.LINE1.5 = FMT("",'65L'):FMT(R.DR.REG.PASIVAS.PARAM<DR.PASIVAS.PARAM.GRP.REP.RANGE,5>,'26L'):FMT(R.REC1<DR.PAS.GRP.SUB5.LOANS>,'10R'):FMT(FIELD(REC.ID1,'-',2),'R6#14'):FMT(R.REC1<DR.PAS.GRP.SUB5.AMT>,'R2,#18')
        GOSUB ARRY.RANGE5.L1
    END
    IF R.REC1<DR.PAS.GRP.SUB6.LOANS> AND R.REC1<DR.PAS.GRP.SUB6.AMT> THEN
        CNT.LOAN.PR6 += R.REC1<DR.PAS.GRP.SUB6.LOANS>
        TOT.AMT.PR6 += R.REC1<DR.PAS.GRP.SUB6.AMT>
        REP.LINE1.6 = FMT("",'65L'):FMT(R.DR.REG.PASIVAS.PARAM<DR.PASIVAS.PARAM.GRP.REP.RANGE,6>,'26L'):FMT(R.REC1<DR.PAS.GRP.SUB6.LOANS>,'10R'):FMT(FIELD(REC.ID1,'-',2),'R6#14'):FMT(R.REC1<DR.PAS.GRP.SUB6.AMT>,'R2,#18')
        GOSUB ARRY.RANGE6.L1
    END
    IF R.REC1<DR.PAS.GRP.SUB7.LOANS> AND R.REC1<DR.PAS.GRP.SUB7.AMT> THEN
        CNT.LOAN.PR7 += R.REC1<DR.PAS.GRP.SUB7.LOANS>
        TOT.AMT.PR7 += R.REC1<DR.PAS.GRP.SUB7.AMT>
        REP.LINE1.7 = FMT("",'65L'):FMT(R.DR.REG.PASIVAS.PARAM<DR.PASIVAS.PARAM.GRP.REP.RANGE,7>,'26L'):FMT(R.REC1<DR.PAS.GRP.SUB7.LOANS>,'10R'):FMT(FIELD(REC.ID1,'-',2),'R6#14'):FMT(R.REC1<DR.PAS.GRP.SUB7.AMT>,'R2,#18')
        GOSUB ARRY.RANGE7.L1
    END
    IF R.REC1<DR.PAS.GRP.SUB8.LOANS> AND R.REC1<DR.PAS.GRP.SUB8.AMT> THEN
        CNT.LOAN.PR8 += R.REC1<DR.PAS.GRP.SUB8.LOANS>
        TOT.AMT.PR8 += R.REC1<DR.PAS.GRP.SUB8.AMT>
        REP.LINE1.8 = FMT("",'65L'):FMT(R.DR.REG.PASIVAS.PARAM<DR.PASIVAS.PARAM.GRP.REP.RANGE,8>,'26L'):FMT(R.REC1<DR.PAS.GRP.SUB8.LOANS>,'10R'):FMT(FIELD(REC.ID1,'-',2),'R6#14'):FMT(R.REC1<DR.PAS.GRP.SUB8.AMT>,'R2,#18')
        GOSUB ARRY.RANGE8.L1
    END
RETURN

WRITE.BODY.PARA2:
****************
    REP.LINE0 = FMT(R.DR.REG.PASIVAS.PARAM<DR.PASIVAS.PARAM.GRP.REP.NAME,5>,'65L')
    RETURN.ARR<-1> = REP.LINE0
    GOSUB INIT.VAR
    LOOP
        REMOVE REC.ID1 FROM ID.LIST2 SETTING ID.POS2
    WHILE REC.ID1:ID.POS2
        YPASIVAS.ID = REC.ID1
        GOSUB READ.PASIVAS.WORK
        GOSUB BODY.PARA1.CASE
    REPEAT
    GOSUB RETURN.ARRY.WRITE
RETURN

WRITE.BODY.PARA3:
****************
    REP.LINE0 = FMT(R.DR.REG.PASIVAS.PARAM<DR.PASIVAS.PARAM.GRP.REP.NAME,6>,'65L')
    RETURN.ARR<-1> = REP.LINE0
    GOSUB INIT.VAR
    LOOP
        REMOVE REC.ID1 FROM ID.LIST3 SETTING ID.POS3
    WHILE REC.ID1:ID.POS3
        YPASIVAS.ID = REC.ID1
        GOSUB READ.PASIVAS.WORK
        GOSUB BODY.PARA1.CASE
    REPEAT
    GOSUB RETURN.ARRY.WRITE
RETURN

WRITE.BODY.PARA4:
****************
    REP.LINE0 = FMT(R.DR.REG.PASIVAS.PARAM<DR.PASIVAS.PARAM.GRP.REP.NAME,7>,'65L')
    RETURN.ARR<-1> = REP.LINE0
    GOSUB INIT.VAR
    LOOP
        REMOVE REC.ID1 FROM ID.LIST4 SETTING ID.POS4
    WHILE REC.ID1:ID.POS4
        YPASIVAS.ID = REC.ID1
        GOSUB READ.PASIVAS.WORK
        GOSUB BODY.PARA1.CASE
    REPEAT
    GOSUB RETURN.ARRY.WRITE
RETURN

WRITE.BODY.PARA5:
****************
    REP.LINE0 = FMT(R.DR.REG.PASIVAS.PARAM<DR.PASIVAS.PARAM.GRP.REP.NAME,8>,'65L')
    RETURN.ARR<-1> = REP.LINE0
    GOSUB INIT.VAR
    LOOP
        REMOVE REC.ID1 FROM ID.LIST5 SETTING ID.POS5
    WHILE REC.ID1:ID.POS5
        YPASIVAS.ID = REC.ID1
        GOSUB READ.PASIVAS.WORK
        GOSUB BODY.PARA1.CASE
    REPEAT
    GOSUB RETURN.ARRY.WRITE
RETURN

WRITE.BODY.PARA6:
****************
    REP.LINE0 = FMT(R.DR.REG.PASIVAS.PARAM<DR.PASIVAS.PARAM.GRP.REP.NAME,9>,'65L')
    RETURN.ARR<-1> = REP.LINE0
    GOSUB INIT.VAR
    LOOP
        REMOVE REC.ID1 FROM ID.LIST6 SETTING ID.POS6
    WHILE REC.ID1:ID.POS6
        YPASIVAS.ID = REC.ID1
        GOSUB READ.PASIVAS.WORK
        GOSUB BODY.PARA1.CASE
    REPEAT
    GOSUB RETURN.ARRY.WRITE
RETURN
*-------------------------------------------------------------------
WRITE.BODY.PARA7:
****************
    REP.LINE0 = FMT(R.DR.REG.PASIVAS.PARAM<DR.PASIVAS.PARAM.GRP.REP.NAME,10>,'65L')
    RETURN.ARR<-1> = REP.LINE0
    GOSUB INIT.VAR
    LOOP
        REMOVE REC.ID1 FROM ID.LIST7 SETTING ID.POS7
    WHILE REC.ID1:ID.POS7
        YPASIVAS.ID = REC.ID1
        GOSUB READ.PASIVAS.WORK
        GOSUB BODY.PARA1.CASE
    REPEAT
    GOSUB RETURN.ARRY.WRITE
RETURN
*-------------------------------------------------------------------
WRITE.BODY.PARA8:
****************
    REP.LINE0 = FMT(R.DR.REG.PASIVAS.PARAM<DR.PASIVAS.PARAM.GRP.REP.NAME,11>,'65L')
    RETURN.ARR<-1> = REP.LINE0
    GOSUB INIT.VAR
    LOOP
        REMOVE REC.ID8 FROM ID.LIST8 SETTING ID.POS8
    WHILE REC.ID8:ID.POS8
        YPASIVAS.ID = REC.ID8
        GOSUB READ.PASIVAS.WORK
        GOSUB PARA8.LOAN.CASE
    REPEAT
    IF RETURN.ARR.PR1 THEN
        RETURN.ARR<-1> = RETURN.ARR.PR1:@FM:FMT("SubTotal:",'65L'):FMT("","26L"):FMT(CNT.LOAN.PR1,'10R'):FMT('','14R'):FMT(TOT.AMT.PR1,'R2,#18')
    END
    IF RETURN.ARR.PR2 THEN
        RETURN.ARR<-1> = RETURN.ARR.PR2:@FM:FMT("SubTotal:",'65L'):FMT("","26L"):FMT(CNT.LOAN.PR2,'10R'):FMT('','14R'):FMT(TOT.AMT.PR2,'R2,#18')
    END
    IF RETURN.ARR.PR3 THEN
        RETURN.ARR<-1> = RETURN.ARR.PR3:@FM:FMT("SubTotal:",'65L'):FMT("","26L"):FMT(CNT.LOAN.PR3,'10R'):FMT('','14R'):FMT(TOT.AMT.PR3,'R2,#18')
    END
    IF RETURN.ARR.PR4 THEN
        RETURN.ARR<-1> = RETURN.ARR.PR4:@FM:FMT("SubTotal:",'65L'):FMT("","26L"):FMT(CNT.LOAN.PR4,'10R'):FMT('','14R'):FMT(TOT.AMT.PR4,'R2,#18')
    END
    CNT.LOAN = CNT.LOAN.PR1 + CNT.LOAN.PR2 + CNT.LOAN.PR3 + CNT.LOAN.PR4
    TOT.AMT = TOT.AMT.PR1 + TOT.AMT.PR2 + TOT.AMT.PR3 + TOT.AMT.PR4
    REP.LINE1.TOT = FMT("Total:",'65L'):FMT("","26L"):FMT(CNT.LOAN,'10R'):FMT('','14R'):FMT(TOT.AMT,'R2,#18')
    IF CNT.LOAN OR TOT.AMT THEN
        RETURN.ARR<-1> = REP.LINE1.TOT
    END
RETURN

PARA8.LOAN.CASE:
****************
    REP.LINE1.1 = ''; REP.LINE1.2 = ''; REP.LINE1.3 = ''; REP.LINE1.4 = ''
    IF R.REC1<DR.PAS.GRP.SUB1.LOANS> AND R.REC1<DR.PAS.GRP.SUB1.AMT> THEN
        CNT.LOAN.PR1 += R.REC1<DR.PAS.GRP.SUB1.LOANS>
        TOT.AMT.PR1 += R.REC1<DR.PAS.GRP.SUB1.AMT>
        REP.LINE1.1 = FMT("",'65L'):FMT(R.DR.REG.PASIVAS.PARAM<DR.PASIVAS.PARAM.GRP.MM.RANGE,1>,'26L'):FMT(R.REC1<DR.PAS.GRP.SUB1.LOANS>,'10R'):FMT(FIELD(REC.ID8,'-',2),'R6#14'):FMT(R.REC1<DR.PAS.GRP.SUB1.AMT>,'R2,#18') ;* Byron - PACS00305233 S/E
        GOSUB ARRY.RANGE1.L1
    END
    IF R.REC1<DR.PAS.GRP.SUB2.LOANS> AND R.REC1<DR.PAS.GRP.SUB2.AMT> THEN
        CNT.LOAN.PR2 += R.REC1<DR.PAS.GRP.SUB2.LOANS>
        TOT.AMT.PR2 += R.REC1<DR.PAS.GRP.SUB2.AMT>
        REP.LINE1.2 = FMT("",'65L'):FMT(R.DR.REG.PASIVAS.PARAM<DR.PASIVAS.PARAM.GRP.MM.RANGE,2>,'26L'):FMT(R.REC1<DR.PAS.GRP.SUB2.LOANS>,'10R'):FMT(FIELD(REC.ID8,'-',2),'R6#14'):FMT(R.REC1<DR.PAS.GRP.SUB2.AMT>,'R2,#18') ;* Byron - PACS00305233 S/E
        GOSUB ARRY.RANGE2.L1
    END
    IF R.REC1<DR.PAS.GRP.SUB3.LOANS> AND R.REC1<DR.PAS.GRP.SUB3.AMT> THEN
        CNT.LOAN.PR3 += R.REC1<DR.PAS.GRP.SUB3.LOANS>
        TOT.AMT.PR3 += R.REC1<DR.PAS.GRP.SUB3.AMT>
        REP.LINE1.3 = FMT("",'65L'):FMT(R.DR.REG.PASIVAS.PARAM<DR.PASIVAS.PARAM.GRP.MM.RANGE,3>,'26L'):FMT(R.REC1<DR.PAS.GRP.SUB3.LOANS>,'10R'):FMT(FIELD(REC.ID8,'-',2),'R6#14'):FMT(R.REC1<DR.PAS.GRP.SUB3.AMT>,'R2,#18')
        GOSUB ARRY.RANGE3.L1
    END
    IF R.REC1<DR.PAS.GRP.SUB4.LOANS> AND R.REC1<DR.PAS.GRP.SUB4.AMT> THEN
        CNT.LOAN.PR4 += R.REC1<DR.PAS.GRP.SUB4.LOANS>
        TOT.AMT.PR4 += R.REC1<DR.PAS.GRP.SUB4.AMT>
        REP.LINE1.4 = FMT("",'65L'):FMT(R.DR.REG.PASIVAS.PARAM<DR.PASIVAS.PARAM.GRP.MM.RANGE,4>,'26L'):FMT(R.REC1<DR.PAS.GRP.SUB4.LOANS>,'10R'):FMT(FIELD(REC.ID8,'-',2),'R6#14'):FMT(R.REC1<DR.PAS.GRP.SUB4.AMT>,'R2,#18')
        GOSUB ARRY.RANGE4.L1
    END
RETURN

ARRY.RANGE1.L1:
***************
    IF REP.LINE1.1 THEN
        RETURN.ARR.PR1<-1> = REP.LINE1.1
    END
RETURN

ARRY.RANGE2.L1:
***************
    IF REP.LINE1.2 THEN
        RETURN.ARR.PR2<-1> = REP.LINE1.2
    END
RETURN
ARRY.RANGE3.L1:
***************
    IF REP.LINE1.3 THEN
        RETURN.ARR.PR3<-1> = REP.LINE1.3
    END
RETURN
ARRY.RANGE4.L1:
***************
    IF REP.LINE1.4 THEN
        RETURN.ARR.PR4<-1> = REP.LINE1.4
    END
RETURN
ARRY.RANGE5.L1:
***************
    IF REP.LINE1.5 THEN
        RETURN.ARR.PR5<-1> = REP.LINE1.5
    END
RETURN
ARRY.RANGE6.L1:
***************
    IF REP.LINE1.6 THEN
        RETURN.ARR.PR6<-1> = REP.LINE1.6
    END
RETURN
ARRY.RANGE7.L1:
***************
    IF REP.LINE1.7 THEN
        RETURN.ARR.PR7<-1> = REP.LINE1.7
    END
RETURN
ARRY.RANGE8.L1:
***************
    IF REP.LINE1.8 THEN
        RETURN.ARR.PR8<-1> = REP.LINE1.8
    END
RETURN

RETURN.ARRY.WRITE:
******************
    IF RETURN.ARR.PR1 THEN
        RETURN.ARR<-1> = RETURN.ARR.PR1:@FM:FMT("SubTotal:",'65L'):FMT("","26L"):FMT(CNT.LOAN.PR1,'10R'):FMT('','14R'):FMT(TOT.AMT.PR1,'R2,#18')
    END
    IF RETURN.ARR.PR2 THEN
        RETURN.ARR<-1> = RETURN.ARR.PR2:@FM:FMT("SubTotal:",'65L'):FMT("","26L"):FMT(CNT.LOAN.PR2,'10R'):FMT('','14R'):FMT(TOT.AMT.PR2,'R2,#18')
    END
    IF RETURN.ARR.PR3 THEN
        RETURN.ARR<-1> = RETURN.ARR.PR3:@FM:FMT("SubTotal:",'65L'):FMT("","26L"):FMT(CNT.LOAN.PR3,'10R'):FMT('','14R'):FMT(TOT.AMT.PR3,'R2,#18')
    END
    IF RETURN.ARR.PR4 THEN
        RETURN.ARR<-1> = RETURN.ARR.PR4:@FM:FMT("SubTotal:",'65L'):FMT("","26L"):FMT(CNT.LOAN.PR4,'10R'):FMT('','14R'):FMT(TOT.AMT.PR4,'R2,#18')
    END
    IF RETURN.ARR.PR5 THEN
        RETURN.ARR<-1> = RETURN.ARR.PR5:@FM:FMT("SubTotal:",'65L'):FMT("","26L"):FMT(CNT.LOAN.PR5,'10R'):FMT('','14R'):FMT(TOT.AMT.PR5,'R2,#18')
    END
    IF RETURN.ARR.PR6 THEN
        RETURN.ARR<-1> = RETURN.ARR.PR6:@FM:FMT("SubTotal:",'65L'):FMT("","26L"):FMT(CNT.LOAN.PR6,'10R'):FMT('','14R'):FMT(TOT.AMT.PR6,'R2,#18')
    END
    IF RETURN.ARR.PR7 THEN
        RETURN.ARR<-1> = RETURN.ARR.PR7:@FM:FMT("SubTotal:",'65L'):FMT("","26L"):FMT(CNT.LOAN.PR7,'10R'):FMT('','14R'):FMT(TOT.AMT.PR7,'R2,#18')
    END
    IF RETURN.ARR.PR8 THEN
        RETURN.ARR<-1> = RETURN.ARR.PR8:@FM:FMT("SubTotal:",'65L'):FMT("","26L"):FMT(CNT.LOAN.PR8,'10R'):FMT('','14R'):FMT(TOT.AMT.PR8,'R2,#18')
    END
    CNT.LOAN = CNT.LOAN.PR1 + CNT.LOAN.PR2 + CNT.LOAN.PR3 + CNT.LOAN.PR4 + CNT.LOAN.PR5 + CNT.LOAN.PR6 + CNT.LOAN.PR7 + CNT.LOAN.PR8
    TOT.AMT = TOT.AMT.PR1 + TOT.AMT.PR2 + TOT.AMT.PR3 + TOT.AMT.PR4 + TOT.AMT.PR5 + TOT.AMT.PR6 + TOT.AMT.PR7 + TOT.AMT.PR8
    REP.LINE1.TOT = FMT("Total:",'65L'):FMT("","26L"):FMT(CNT.LOAN,'10R'):FMT('','14R'):FMT(TOT.AMT,'R2,#18')
    IF CNT.LOAN OR TOT.AMT THEN
        RETURN.ARR<-1> = REP.LINE1.TOT
    END
    RETURN.ARR.PR1 = ''; RETURN.ARR.PR2 = ''; RETURN.ARR.PR3 = ''; RETURN.ARR.PR4 = ''; RETURN.ARR.PR5 = ''; RETURN.ARR.PR6 = ''
    RETURN.ARR.PR7 = ''; RETURN.ARR.PR8 = ''; REP.LINE1.TOT = ''; CNT.LOAN = ''; TOT.AMT = ''; REP.LINE1.7 = ''; REP.LINE1.8 = ''
    REP.LINE1.1 = ''; REP.LINE1.2 = ''; REP.LINE1.3 = ''; REP.LINE1.4 = ''; REP.LINE1.5 = ''; REP.LINE1.6 = ''
    CNT.LOAN.PR1 = ''; CNT.LOAN.PR2 = ''; CNT.LOAN.PR3 = ''; CNT.LOAN.PR4 = ''; CNT.LOAN.PR5 = ''; CNT.LOAN.PR6 = ''; CNT.LOAN.PR7 = ''; CNT.LOAN.PR8 = ''
    TOT.AMT.PR1 = ''; TOT.AMT.PR2 = ''; TOT.AMT.PR3 = ''; TOT.AMT.PR4 = ''; TOT.AMT.PR5 = ''; TOT.AMT.PR6 = ''; TOT.AMT.PR7 = ''; TOT.AMT.PR8 = ''
RETURN

READ.PASIVAS.WORK:
******************
    CALL F.READ(FN.DR.REG.PASIVAS.WORKFILE, YPASIVAS.ID, R.REC1, F.DR.REG.PASIVAS.WORKFILE, RD.ERR)
RETURN

END
