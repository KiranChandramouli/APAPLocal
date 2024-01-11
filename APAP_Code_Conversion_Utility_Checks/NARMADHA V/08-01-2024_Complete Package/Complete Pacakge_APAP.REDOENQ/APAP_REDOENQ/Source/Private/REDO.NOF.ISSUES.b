* @ValidationCode : MjoxNjQzMTE2NjU5OlVURi04OjE3MDQzNjIwNjc5MDM6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Jan 2024 15:24:27
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOF.ISSUES(Y.FIN.ARR)
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.NOF.ISSUES
*--------------------------------------------------------------------------------------------------------
*Description  :   To display opened cases and interactions with SLA applicable to each case,
*                 solution average percentage, and closed interactions and cases before their expiration,
*                 using a filter for Support Group, Channel Opening, Case Number, User, Month, Status and
*                 Transaction Date
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 09 MAR 2011     SRIRAMAN.C           ODR-2010-12-0244          Initial Creation
* 21 MAR 2011     MARIMUTHU S          ODR-2010-12-0244          CHANGES MADE
* 08-09-2011      MANJU.G              PACS00104863              Change ON TIME to ON.TIME
* 10 May 2015    Ashokkumar.V.P        PACS00348153              Change to display in correct format
* 13-APRIL-2023      Conversion Tool       R22 Auto Conversion - VM to @VM , FM to @FM , ++ to += and SM to @SM
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes
* 24-NOV-2023        Edwin                 R22 Manual Conversion
* 04-01-2024         Narmadha V            Manual R22 Conversion   F.READ to CACHE.READ
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.ISSUE.CLAIMS
    $INSERT I_F.REDO.ISSUE.COMPLAINTS
    $INSERT I_F.REDO.ISSUE.REQUESTS
    $INSERT I_F.REDO.SLA.PARAM
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.REDO.U.CRM.PRODUCT.TYPE

    GOSUB INIT
    GOSUB GET.SELECTION
    Y.LABEL  = ('Producto : ') : Y.HEAD.PRO.TYPE
    Y.LABEL := @FM:('Estatus del Caso : ') : Y.HEAD.CL.STATUS
    Y.LABEL := @FM:('Tipo Caso o interaccion : ') : Y.TYPE
    CALL EB.DATE.FORMAT.DISPLAY(Y.HEAD.OPEN.DT,Y.HEAD.OPEN.OUT,'','')
    Y.LABEL := @FM:('Fecha Apertura Caso : ') : Y.HEAD.OPEN.OUT
    CALL EB.DATE.FORMAT.DISPLAY(Y.HEAD.CLOSE.DT,Y.HEAD.CLOSE.OUT,'','')
    Y.LABEL := @FM:('Fecha Cierre de Caso : ') : Y.HEAD.CLOSE.OUT
    Y.LABEL := @FM:('Tipo/Razon CasoInter : ') : Y.HEAD.CLAIM.TYPE
    Y.HEAD.INPUTTER = FIELD(Y.HEAD.INPUTTER,"___",1,1)
    Y.HEAD.INPUTTER = FIELD(Y.HEAD.INPUTTER,"_",2)
    Y.LABEL := @FM:('Usuarion Apert Caso : ') : Y.HEAD.INPUTTER
    Y.LABEL := @FM:('Groupo de Apoyo : ') : Y.HEAD.SUPP.GRP
    Y.LABEL := @FM:('Canal de Apertura : ') : Y.HEAD.OPEN.CHNL
    Y.LABEL := @FM:"____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________"
    Y.LABEL := "_________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________"
    Y.LABEL := @FM:FMT('Producto  ','L#40')
    Y.LABEL := FMT('Mes01 SLA  ','L#40'):' ' :FMT('Mes01 Prom cierrSLA  ','L#40'):' ':FMT('Mes01%cierrantex SLA  ','L#40')
    Y.LABEL := FMT('Mes02 SLA  ','L#40'):' ' :FMT('Mes02 Prom cierrSLA  ','L#40'):' ':FMT('Mes02%cierrantex SLA  ','L#40')
    Y.LABEL := FMT('Mes03 SLA  ','L#40'):' ' :FMT('Mes03 Prom cierrSLA  ','L#40'):' ':FMT('Mes03%cierrantex SLA  ','L#40')
    Y.LABEL := FMT('Mes04 SLA  ','L#40'):' ' :FMT('Mes04 Prom cierrSLA  ','L#40'):' ':FMT('Mes04%cierrantex SLA  ','L#40')
    Y.LABEL := FMT('Mes05 SLA  ','L#40'):' ' :FMT('Mes05 Prom cierrSLA  ','L#40'):' ':FMT('Mes05%cierrantex SLA  ','L#40')
    Y.LABEL := FMT('Mes06 SLA  ','L#40'):' ' :FMT('Mes06 Prom cierrSLA  ','L#40'):' ':FMT('Mes06%cierrantex SLA  ','L#40')
    Y.LABEL := FMT('Mes07 SLA  ','L#40'):' ' :FMT('Mes07 Prom cierrSLA  ','L#40'):' ':FMT('Mes07%cierrantex SLA  ','L#40')
    Y.LABEL := FMT('Mes08 SLA  ','L#40'):' ' :FMT('Mes08 Prom cierrSLA  ','L#40'):' ':FMT('Mes08%cierrantex SLA  ','L#40')
    Y.LABEL := FMT('Mes09 SLA  ','L#40'):' ' :FMT('Mes09 Prom cierrSLA  ','L#40'):' ':FMT('Mes09%cierrantex SLA  ','L#40')
    Y.LABEL := FMT('Mes10 SLA  ','L#40'):' ' :FMT('Mes10 Prom cierrSLA  ','L#40'):' ':FMT('Mes10%cierrantex SLA  ','L#40')
    Y.LABEL := FMT('Mes11 SLA  ','L#40'):' ' :FMT('Mes11 Prom cierrSLA  ','L#40'):' ':FMT('Mes11%cierrantex SLA  ','L#40')
    Y.LABEL := FMT('Mes12 SLA  ','L#40'):' ' :FMT('Mes12 Prom cierrSLA  ','L#40'):' ':FMT('Mes12%cierrantex SLA  ','L#40')
    Y.LABEL := @FM:"____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________"
    Y.LABEL := "_________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________"
    Y.FIN.ARR = Y.LABEL:@FM:Y.FIN.ARR
RETURN
*------------------------------------------------------------------------------
******
INIT:
******
    Y.TYPE = '';Y.APPL = '';Y.RECLAMACION.FLAG = '';Y.INTERACCION.FLAG = '';Y.SOLICITUD.FLAG = '';Y.PROD.TYPE = ''
    Y.CASE.STATUS = '';Y.CUS.CODE = '';Y.BRANCH = '';Y.OPEN.MONTH.FROM = '';Y.OPEN.MONTH.TO = '';Y.CLOSE.MONTH.FROM = ''
    Y.OPEN.DATE.FROM = '';Y.OPEN.DATE.TO = '';Y.CLOSE.DATE.FROM = '';Y.CLOSE.DATE.TO = '';Y.CASE.USER = ''
    Y.OPEN.CHANNEL = '';Y.RISK = '';Y.SUPPORT.GROUP = '';Y.SEGMENT = '';Y.SEL.ID = '';Y.STATUS = ''
    Y.DIFF.DAYS = '';Y.OPENING.DATE = '';Y.CLOSING.DATE = '';SLA.ID = '';Y.MON = '';Y.STR = ''; Y.TOT.PROD.TYPE = ''
    CK.PDT = '';CK.MON = '';SUPGRP = '';Y.SEG = '';SEG.DAYS = '';Y.NOF.DAYS = '';Y.CHK.MON.FROM = '';NOF.DAYS = '';Y.SUM = ''

    FN.REDO.ISSUE.CLAIMS='F.REDO.ISSUE.CLAIMS'
    F.REDO.ISSUE.CLAIMS=''
    CALL OPF(FN.REDO.ISSUE.CLAIMS,F.REDO.ISSUE.CLAIMS)

    FN.REDO.ISSUE.COMPLAINTS='F.REDO.ISSUE.COMPLAINTS'
    F.REDO.ISSUE.COMPLAINTS=''
    CALL OPF(FN.REDO.ISSUE.COMPLAINTS,F.REDO.ISSUE.COMPLAINTS)

    FN.REDO.ISSUE.REQUESTS='F.REDO.ISSUE.REQUESTS'
    F.REDO.ISSUE.REQUESTS=''
    CALL OPF(FN.REDO.ISSUE.REQUESTS,F.REDO.ISSUE.REQUESTS)

    FN.REDO.SLA.PARAM = 'F.REDO.SLA.PARAM'
    F.REDO.SLA.PARAM  =''
    CALL OPF(FN.REDO.SLA.PARAM,F.REDO.SLA.PARAM)

    FN.REDO.U.CRM.PRODUCT.TYPE = 'F.REDO.U.CRM.PRODUCT.TYPE'
    F.REDO.U.CRM.PRODUCT.TYPE = ''
    CALL OPF(FN.REDO.U.CRM.PRODUCT.TYPE,F.REDO.U.CRM.PRODUCT.TYPE)

    FN.EB.LOOKUP = 'F.EB.LOOKUP'; F.EB.LOOKUP = ''
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)

    FORM.MONTH.ARRAY = '01':@FM:'02':@FM:'03':@FM:'04':@FM:'05':@FM:'06':@FM:'07':@FM:'08':@FM:'09':@FM:'10':@FM:'11':@FM:'12'
    APPL = ''
    Y.EL.ID = "CM.STATUS"
    Y.SUP.GRP.ID = 'SUPPORT.GROUP'
    Y.OPN.CHL.ID = 'OPENING.CHANNEL'
RETURN
*------------------------------------------------------------------------------
*****************************
GET.SELECTION:
*****************************
    LOCATE "CASE.TYPE" IN D.FIELDS<1> SETTING TYPE.POS THEN
        Y.TYPE = D.RANGE.AND.VALUE<TYPE.POS>
    END
    IF Y.TYPE THEN
        GOSUB SELECT.CASE
    END
    GOSUB LOCATE.FIELDS
RETURN

************
SELECT.CASE:
************
    BEGIN CASE
        CASE Y.TYPE EQ 'RECLAMACION'
            SEL.CMD = "SELECT ":FN.REDO.ISSUE.CLAIMS:" WITH TYPE EQ ": Y.TYPE
            Y.APPL = FN.REDO.ISSUE.CLAIMS
            Y.RECLAMACION.FLAG = '1'

        CASE Y.TYPE EQ 'QUEJAS'
            SEL.CMD = "SELECT ":FN.REDO.ISSUE.COMPLAINTS:" WITH TYPE EQ ":Y.TYPE
            Y.APPL = FN.REDO.ISSUE.COMPLAINTS
            Y.INTERACCION.FLAG = '1'

        CASE Y.TYPE EQ 'SOLICITUD'
            SEL.CMD = "SELECT ":FN.REDO.ISSUE.REQUESTS:" WITH TYPE EQ ":Y.TYPE
            Y.APPL = FN.REDO.ISSUE.REQUESTS
            Y.SOLICITUD.FLAG = '1'

    END CASE
RETURN

**************
LOCATE.FIELDS:
**************
    LOCATE "PRODUCT.TYPE" IN D.FIELDS<1> SETTING PROD.TYPE.POS THEN
        Y.PROD.TYPE = D.RANGE.AND.VALUE<PROD.TYPE.POS>
        SEL.CMD := " AND PRODUCT.TYPE EQ '":Y.PROD.TYPE:"'"
    END
    LOCATE "CASE.STATUS" IN D.FIELDS<1> SETTING CASE.STATUS.POS THEN
        Y.CASE.STATUS = D.RANGE.AND.VALUE<CASE.STATUS.POS>
        SEL.CMD := " AND STATUS EQ '":Y.CASE.STATUS:"'"
    END
    LOCATE "CLIENT.NUMBER" IN D.FIELDS<1> SETTING CUS.CODE.POS THEN
        Y.CUS.CODE = D.RANGE.AND.VALUE<CUS.CODE.POS>
        SEL.CMD := " AND CUSTOMER.CODE EQ '":Y.CUS.CODE:"'"
    END
    LOCATE "BRANCH" IN D.FIELDS<1> SETTING BRANCH.POS THEN
        Y.BRANCH = D.RANGE.AND.VALUE<BRANCH.POS>
        SEL.CMD := " AND BRANCH EQ '":Y.BRANCH:"'"
    END
    LOCATE "OPEN.MONTH" IN D.FIELDS<1> SETTING OPEN.MON.FROM.POS THEN
        Y.OPEN.MONTH.FROM = D.RANGE.AND.VALUE<OPEN.MON.FROM.POS>
    END
    LOCATE "CLOSE.MONTH" IN D.FIELDS<1> SETTING CLOSE.MONTH.FROM.POS THEN
        Y.CLOSE.MONTH.FROM = D.RANGE.AND.VALUE<CLOSE.MONTH.FROM.POS>
    END
    LOCATE "OPEN.DATE.FROM" IN D.FIELDS<1> SETTING OPEN.DATE.FROM.POS THEN
        Y.OPEN.DATE.FROM = D.RANGE.AND.VALUE<OPEN.DATE.FROM.POS>
        LOCATE "OPEN.DATE.TO" IN D.FIELDS<1> SETTING OPEN.DATE.TO.POS THEN
            Y.OPEN.DATE.TO = D.RANGE.AND.VALUE<OPEN.DATE.TO.POS>
        END
    END
    LOCATE "CLOSE.DATE.FROM" IN D.FIELDS<1> SETTING CLOSE.DATE.FROM.POS THEN
        Y.CLOSE.DATE.FROM = D.RANGE.AND.VALUE<CLOSE.DATE.FROM.POS>
    END
    LOCATE "CLOSE.DATE.TO" IN D.FIELDS<1> SETTING CLOSE.DATE.TO.POS THEN
        Y.CLOSE.DATE.TO = D.RANGE.AND.VALUE<CLOSE.DATE.TO.POS>
    END

    BEGIN CASE
        CASE Y.OPEN.MONTH.FROM NE ''
            GOSUB GETTING.MONTH.VALUE
        CASE Y.CLOSE.MONTH.FROM  NE ''
            GOSUB GETTING.MONTH.VALUE.CLOSE
        CASE Y.OPEN.DATE.FROM NE ''
            SEL.CMD := " AND OPENING.DATE GE ":Y.OPEN.DATE.FROM:" AND OPENING.DATE LE ":Y.OPEN.DATE.TO
            Y.CHK.MON.FROM = Y.OPEN.DATE.FROM
        CASE Y.CLOSE.DATE.FROM NE ''
            SEL.CMD := " AND CLOSING.DATE GE ":Y.CLOSE.DATE.FROM:" AND CLOSING.DATE LE ":Y.CLOSE.DATE.TO
            Y.CHK.MON.FROM = Y.CLOSE.DATE.FROM
    END CASE

    LOCATE "CASE.USER" IN D.FIELDS<1> SETTING CASE.USER.POS THEN
        Y.CASE.USER = D.RANGE.AND.VALUE<CASE.USER.POS>
        SEL.CMD := " AND INPUTTER LIKE ...":Y.CASE.USER:"..."
    END

    LOCATE "OPENING.CHANNEL" IN D.FIELDS<1> SETTING OPENING.CHANNEL.POS THEN
        Y.OPEN.CHANNEL = D.RANGE.AND.VALUE<OPENING.CHANNEL.POS>
        SEL.CMD := " AND OPENING.CHANNEL EQ '":Y.OPEN.CHANNEL:"'"
    END
    LOCATE "SUPPORT.GROUP" IN D.FIELDS<1> SETTING SUPORT.GROUP.POS THEN
        Y.SUP.GROUP = D.RANGE.AND.VALUE<SUPORT.GROUP.POS>
        SEL.CMD := " AND SUPPORT.GROUP EQ '":Y.SUP.GROUP:"'"
    END

    GOSUB CHECK.REDO.SLA.PARAM
RETURN
*******************
GETTING.MONTH.VALUE:
*******************
    Y.DUP.OPEN.MONTH.FROM = Y.OPEN.MONTH.FROM:'M'
    CALL CALENDAR.DAY(TODAY,'-',Y.DUP.OPEN.MONTH.FROM)

    SEL.CMD := " AND OPENING.DATE GE ":Y.DUP.OPEN.MONTH.FROM:" AND OPENING.DATE LE ":TODAY
RETURN
*******************
GETTING.MONTH.VALUE.CLOSE:
*******************
    Y.DUP.CLOSE.DATE.TO = Y.CLOSE.MONTH.FROM:'M'
    CALL CALENDAR.DAY(TODAY,'-',Y.DUP.CLOSE.DATE.TO)

    SEL.CMD := " AND CLOSING.DATE GE ":Y.DUP.CLOSE.DATE.TO:" AND CLOSING.DATE LE ":TODAY
RETURN

**********************
CHECK.REDO.SLA.PARAM:
**********************
    LOCATE "RISK" IN D.FIELDS<1> SETTING RISK.POS THEN
        Y.RISK = D.RANGE.AND.VALUE<RISK.POS>
    END

    LOCATE "SUPPORT.GROUP" IN D.FIELDS<1> SETTING SUPPORT.GROUP.POS THEN
        Y.SUPPORT.GROUP = D.RANGE.AND.VALUE<SUPPORT.GROUP.POS>
    END

    LOCATE "START.CHANNEL" IN D.FIELDS<1> SETTING START.CHANNEL.POS THEN
        Y.START.CHANNEL = D.RANGE.AND.VALUE<START.CHANNEL.POS>
    END

    IF Y.RISK THEN
        SEL.PARAM = "SELECT ":FN.REDO.SLA.PARAM:" WITH @ID LIKE ":Y.TYPE:"-... AND RISK.LEVEL EQ ":Y.RISK
    END ELSE
        SEL.PARAM = "SELECT ":FN.REDO.SLA.PARAM:" WITH @ID LIKE ":Y.TYPE:"-... AND RISK.LEVEL NE '' "
    END

    IF Y.SUPPORT.GROUP  THEN
        SEL.PARAM := " AND SUPPORT.GROUP EQ '":Y.SUPPORT.GROUP:"'"
    END

    IF Y.START.CHANNEL THEN
        SEL.PARAM := " AND START.CHANNEL EQ '":Y.START.CHANNEL:"'"
    END

    CALL EB.READLIST(SEL.PARAM,SEL.LIST.PARAM,"",SEL.CNT.P,SEL.ERR)
    CHANGE @FM TO " " IN SEL.LIST.PARAM

    SEL.CMD := " AND CLOSING.DATE  NE '' "
    SEL.CMD := " AND SLA.ID MATCHES ":SEL.LIST.PARAM
    SEL.DUP.CMD = SEL.CMD
    SEL.CMD := " BY PRODUCT.TYPE BY OPENING.DATE "
    SEL.DUP.CMD := " BY OPENING.DATE "
    IF SEL.LIST.PARAM THEN    ;* R22 Code conversion changes
        CALL EB.READLIST(SEL.CMD,SEL.LIST,"",SEL.CNT,SEL.ERR)

        CALL EB.READLIST(SEL.DUP.CMD,SEL.DUP.LIST,'',NO.OF.RECS,SEL.DUP.ERR)
    END
    IF SEL.LIST THEN
        GOSUB PROCESS
    END
RETURN
*********
PROCESS:
*********
    SEL.PRD = ''; SEL.LISTP = ''; NO.OF.RECP = ''; SELP.ERR = ''
    SEL.PRD = "SSELECT ":FN.REDO.U.CRM.PRODUCT.TYPE
    CALL EB.READLIST(SEL.PRD,SEL.LISTP,'',NO.OF.RECP,SELP.ERR)

    SUM1 = 0
    FLAG  = 1
    ONTIME.CNT = 0
    PDT.CNT = 0
    Y.MONTH.STR = 'Mes '
    Y.HEAD.1 = FMT('Producto','L#40')
    Y.HEAD.2 = FMT(' ','L#40')
    Y.DUP.MON = FORM.MONTH.ARRAY
    LOOP
        REMOVE Y.SEL.ID FROM FORM.MONTH.ARRAY SETTING POS.DUP
    WHILE Y.SEL.ID:POS.DUP
        Y.MON.STR = Y.SEL.ID
        IF FLG.TT EQ '' THEN
            Y.STR.DUP = Y.MONTH.STR:Y.MON.STR
            Y.STORE.MN<-1> = Y.MON.STR
            Y.MON.FIN.1 = FMT('Mes Apertura Caso','L#75'):FMT(Y.STR.DUP,'L#120')
            FLG.TT = 1
        END ELSE
            Y.STR.DUP = Y.MONTH.STR:Y.MON.STR
            Y.STORE.MN<-1> = Y.MON.STR
            Y.MON.FIN.1 := FMT(Y.STR.DUP,'L#120')
        END
        Y.HEAD.1 := FMT('Acuerdo de Servicio SLA','L#40'):FMT('Tiempo Promedio Casos o','L#40'):FMT('% Casos o Interacciones Cerrados','L#40')
        Y.HEAD.2 := FMT(' ','L#40'):FMT('Interacciones Cerrados','L#40'):FMT('Antes del Vencimiento SLA','L#40')
    REPEAT
*    Y.FIN.ARR<-1> = ' ':FM:Y.MON.FIN.1:FM:' ':FM:Y.HEAD.1:FM:Y.HEAD.2:FM:' '
    LOOP
        REMOVE Y.SEL.ID FROM SEL.LIST SETTING SEL.POS
    WHILE Y.SEL.ID:SEL.POS
        GOSUB CHECK.APPLICATION
        GOSUB FORM.STR
    REPEAT
    LOOP
        REMOVE Y.SEL.ID FROM SEL.LISTP SETTING SEL.POSN
    WHILE Y.SEL.ID:SEL.POSN
        LOCATE Y.SEL.ID IN Y.TOT.PROD.TYPE<1> SETTING PT.POSN THEN
            CONTINUE
        END
        Y.FIN.ARR<-1> = FMT(Y.SEL.ID,'L#40'):FMT('0','L#40'):FMT('0','L#40'):FMT('0.00','L#40'):FMT('0','L#40'):FMT('0','L#40'):FMT('0.00','L#40'):FMT('0','L#40'):FMT('0','L#40'):FMT('0.00','L#40'):FMT('0','L#40'):FMT('0','L#40'):FMT('0.00','L#40'):FMT('0','L#40'):FMT('0','L#40'):FMT('0.00','L#40'):FMT('0','L#40'):FMT('0','L#40'):FMT('0.00','L#40'):FMT('0','L#40'):FMT('0','L#40'):FMT('0.00','L#40'):FMT('0','L#40'):FMT('0','L#40'):FMT('0.00','L#40'):FMT('0','L#40'):FMT('0','L#40'):FMT('0.00','L#40'):FMT('0','L#40'):FMT('0','L#40'):FMT('0.00','L#40'):FMT('0','L#40'):FMT('0','L#40'):FMT('0.00','L#40'):FMT('0','L#40'):FMT('0','L#40'):FMT('0.00','L#40')
    REPEAT
    GOSUB FOR.AVERAGE
    Y.FIN.ARR<-1> = FMT('Promedio','L#40'):Y.SAMPLE.FM.FIN
    REGION = ''
RETURN

************
FOR.AVERAGE:
************
    Y.CNT.FM = DCOUNT(Y.AVG.TOT.FIN,@FM)
    Y.SAMPLE.FM = Y.AVG.TOT.FIN<1>
    FLG.FMS = 1
    LOOP
    WHILE Y.CNT.FM GT 0 DO
        FLG.FMS += 1
        RTN.ADD.B = TRIM(Y.AVG.TOT.FIN<FLG.FMS>, ' ', 'A')
*        Y.SAMPLE.FM = ADDS(Y.SAMPLE.FM,Y.AVG.TOT.FIN<FLG.FMS>)
        Y.SAMPLE.FM = ADDS(Y.SAMPLE.FM,RTN.ADD.B)
        Y.CNT.FM -= 1
    REPEAT

    Y.SAMPLE.FM = CHANGE(Y.SAMPLE.FM,@SM,@VM)
    Y.CNT.CV = DCOUNT(Y.SAMPLE.FM,@VM)
    FLG.CM.VM = ''
    LOOP
    WHILE Y.CNT.CV GT 0 DO
        FLG.CM.VM += 1
        Y.TT.SAMPLE = Y.SAMPLE.FM<1,FLG.CM.VM>/PRD.CNT
        Y.SAMPLE.FM.FIN := FMT(Y.TT.SAMPLE,'L2#40')
        Y.CNT.CV -= 1
    REPEAT
RETURN

READ.CRM.PRD.TYPE:
******************
    REC.REDO.U.CRM.PRODUCT.TYPE = ''; RUCP.ERR = ''; YRDCP.DESC = ''
    CALL F.READ(FN.REDO.U.CRM.PRODUCT.TYPE,SEL.ID,REC.REDO.U.CRM.PRODUCT.TYPE,F.REDO.U.CRM.PRODUCT.TYPE,RUCP.ERR)
    YRDCP.DESC = REC.REDO.U.CRM.PRODUCT.TYPE<PRD.TYPE.DESCRIPTION>
RETURN

READ.EB.LOOKUP:
***************
    ERR.EBLOOKUP = ''; R.EB.LOOKUP = ''; YSTAT.LOOKUP = ''
    CALL F.READ(FN.EB.LOOKUP,YSTATUS.VAL,R.EB.LOOKUP,F.LOOKUP,ERR.EBLOOKUP)
    YSTAT.LOOKUP = R.EB.LOOKUP<EB.LU.DESCRIPTION,2>
    IF NOT(YSTAT.LOOKUP) THEN
        YSTAT.LOOKUP = R.EB.LOOKUP<EB.LU.DESCRIPTION,1>
    END
RETURN

*****************
CHECK.APPLICATION:
******************
    IF Y.RECLAMACION.FLAG EQ '1' THEN
        CALL F.READ(FN.REDO.ISSUE.CLAIMS,Y.SEL.ID,R.REDO.ISSUE.CLAIMS,F.REDO.ISSUE.CLAIMS,CLAIMS.ERR)
        Y.PRODUCT.TYPE  = R.REDO.ISSUE.CLAIMS<ISS.CL.PRODUCT.TYPE>
        Y.OPENING.DATE = R.REDO.ISSUE.CLAIMS<ISS.CL.OPENING.DATE>
        Y.CLOSING.DATE = R.REDO.ISSUE.CLAIMS<ISS.CL.CLOSING.DATE>
        SLA.ID = R.REDO.ISSUE.CLAIMS<ISS.CL.SLA.ID>
        Y.SEG.AGR.COMP = R.REDO.ISSUE.CLAIMS<ISS.CL.SER.AGR.COMP>
        Y.STATUS   = R.REDO.ISSUE.CLAIMS<ISS.CL.STATUS>
*
        Y.HEAD.OPEN.DT     = Y.OPENING.DATE
        Y.HEAD.CLOSE.DT    = Y.CLOSING.DATE
        Y.HEAD.CLAIM.TYPE  = R.REDO.ISSUE.CLAIMS<ISS.CL.CLAIM.TYPE>
        Y.HEAD.INPUTTER    = R.REDO.ISSUE.CLAIMS<ISS.CL.INPUTTER>
        Y.SUPP.GRP.VAL    = R.REDO.ISSUE.CLAIMS<ISS.CL.SUPPORT.GROUP>
        Y.OPEN.CHNL   = R.REDO.ISSUE.CLAIMS<ISS.CL.OPENING.CHANNEL>
    END

    IF Y.INTERACCION.FLAG EQ '1' THEN
        CALL F.READ(FN.REDO.ISSUE.COMPLAINTS,Y.SEL.ID,R.REDO.ISSUE.COMPLAINTS,F.REDO.ISSUE.COMPLAINTS,ISSUE.ERR)
        Y.OPENING.DATE =  R.REDO.ISSUE.COMPLAINTS<ISS.COMP.OPENING.DATE>
        Y.CLOSING.DATE =  R.REDO.ISSUE.COMPLAINTS<ISS.COMP.CLOSING.DATE>
        Y.STATUS  = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.STATUS>
        Y.PRODUCT.TYPE  = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.PRODUCT.TYPE>
        SLA.ID = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.SLA.ID>
        Y.SEG.AGR.COMP = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.SER.AGR.COMP>
*
        Y.HEAD.OPEN.DT      =  Y.OPENING.DATE
        Y.HEAD.CLOSE.DT     =  Y.CLOSING.DATE
        Y.HEAD.CLAIM.TYPE   =  R.REDO.ISSUE.COMPLAINTS<ISS.COMP.CLAIM.TYPE>
        Y.HEAD.INPUTTER     =  R.REDO.ISSUE.COMPLAINTS<ISS.COMP.INPUTTER>
        Y.SUPP.GRP.VAL     =  R.REDO.ISSUE.COMPLAINTS<ISS.COMP.SUPPORT.GROUP>
        Y.OPEN.CHNL    =  R.REDO.ISSUE.COMPLAINTS<ISS.COMP.OPENING.CHANNEL>
    END
    IF Y.SOLICITUD.FLAG EQ '1' THEN
        CALL F.READ(FN.REDO.ISSUE.REQUESTS,Y.SEL.ID,R.REDO.ISSUE.REQUESTS,F.REDO.ISSUE.REQUESTS,REQUEST.ERR)
        Y.OPENING.DATE = R.REDO.ISSUE.REQUESTS<ISS.REQ.OPENING.DATE>
        Y.CLOSING.DATE = R.REDO.ISSUE.REQUESTS<ISS.REQ.CLOSING.DATE>
        Y.STATUS  = R.REDO.ISSUE.REQUESTS<ISS.REQ.STATUS>
        Y.PRODUCT.TYPE = R.REDO.ISSUE.REQUESTS<ISS.REQ.PRODUCT.TYPE>
        SLA.ID = R.REDO.ISSUE.REQUESTS<ISS.REQ.SLA.ID>
        Y.SEG.AGR.COMP = R.REDO.ISSUE.REQUESTS<ISS.REQ.SER.AGR.COMP>
*
        Y.HEAD.OPEN.DT       = Y.OPENING.DATE
        Y.HEAD.CLOSE.DT      = Y.CLOSING.DATE
        Y.HEAD.CLAIM.TYPE    = R.REDO.ISSUE.REQUESTS<ISS.REQ.CLAIM.TYPE>
        Y.HEAD.INPUTTER      = R.REDO.ISSUE.REQUESTS<ISS.REQ.INPUTTER>
        Y.SUPP.GRP.VAL      = R.REDO.ISSUE.REQUESTS<ISS.REQ.SUPPORT.GROUP>
        Y.OPEN.CHNL     = R.REDO.ISSUE.REQUESTS<ISS.REQ.OPENING.CHANNEL>
    END
    SEL.ID = Y.PRODUCT.TYPE
    GOSUB READ.CRM.PRD.TYPE
    Y.HEAD.PRO.TYPE = YRDCP.DESC
    IF NOT(Y.HEAD.PRO.TYPE) THEN
        Y.HEAD.PRO.TYPE      = Y.PRODUCT.TYPE
    END
    YSTATUS.VAL = ''
    YSTATUS.VAL = Y.EL.ID:'*':Y.STATUS
    GOSUB READ.EB.LOOKUP
    Y.HEAD.CL.STATUS     = YSTAT.LOOKUP
    IF NOT(Y.HEAD.CL.STATUS) THEN
        Y.HEAD.CL.STATUS     = Y.STATUS
    END
    YSTATUS.VAL = ''
    YSTATUS.VAL = Y.SUP.GRP.ID:'*':Y.SUPP.GRP.VAL
    GOSUB READ.EB.LOOKUP
    Y.HEAD.SUPP.GRP     = YSTAT.LOOKUP
    IF NOT(Y.HEAD.SUPP.GRP) THEN
        Y.HEAD.SUPP.GRP     = Y.SUPP.GRP.VAL
    END
    YSTATUS.VAL = ''
    YSTATUS.VAL = Y.OPN.CHL.ID:'*':Y.OPEN.CHNL
    GOSUB READ.EB.LOOKUP
    Y.HEAD.OPEN.CHNL = YSTAT.LOOKUP
    IF NOT(Y.HEAD.OPEN.CHNL) THEN
        Y.HEAD.OPEN.CHNL = Y.OPEN.CHNL
    END
RETURN

*********
FORM.STR:
*********
    Y.MON = Y.OPENING.DATE[5,2]
    NOF.DAYS = 'C'
    CALL CDD(REGION,Y.OPENING.DATE,Y.CLOSING.DATE,NOF.DAYS)
    LOCATE Y.PRODUCT.TYPE IN Y.TOT.PROD.TYPE<1> SETTING PT.POSN ELSE
        Y.TOT.PROD.TYPE<-1> = Y.PRODUCT.TYPE
    END
    IF (Y.PRODUCT.TYPE NE Y.DUP.PROD.TYPE) THEN
        PRD.CNT += 1
        GOSUB SUB.FLAG.SET
        GOSUB FLAG.NOT.SET
        GOSUB SLA.PARAM
        FLG = 0
        Y.DIF.DATE += NOF.DAYS
*PACS00104863-S
        IF Y.SEG.AGR.COMP EQ 'ONTIME' THEN
            FLG.ON += 1
        END
*PACS00104863-E
        Y.DUP.MON = Y.MON
        Y.DUP.PROD.TYPE = Y.PRODUCT.TYPE
        FLG += 1
        FLG.TTS = 1
    END ELSE
        FLG.1 = 'SET'
        IF Y.MON EQ Y.DUP.MON THEN
            FLG += 1
            Y.DIF.DATE += NOF.DAYS
*PACS00104863-S
            IF Y.SEG.AGR.COMP EQ 'ONTIME' THEN
                FLG.ON += 1
            END
*PACS00104863-E
            Y.DUP.MON = Y.MON
        END ELSE
            Y.CLOSE.AVG.TIME = Y.DIF.DATE/FLG
            PERCEN.CLOSE.TIME = (FLG.ON/FLG) * 100
            FLG = 0 ; Y.DIF.DATE = 0; FLG.ON = 0
            LOCATE Y.DUP.MON IN Y.STORE.MN SETTING POS.STORE THEN
                Y.MY.PUR<-1> = Y.DUP.MON
                Y.FIN.ARR.1<POS.STORE,-1> = FMT(SEG.DAYS,'L#40'):FMT(Y.CLOSE.AVG.TIME,'L#40'):FMT(PERCEN.CLOSE.TIME,'L2#40')
                Y.AVG.TOT<POS.STORE,-1> = FMT(SEG.DAYS,'L#40'):@SM:FMT(Y.CLOSE.AVG.TIME,'L#40'):@SM:FMT(PERCEN.CLOSE.TIME,'L2#40')
            END
            Y.DIF.DATE += NOF.DAYS
            IF Y.SEG.AGR.COMP EQ 'ONTIME' THEN
                FLG.ON += 1
            END
            FLG += 1
        END

        Y.DUP.MON = Y.MON
        Y.DUP.PROD.TYPE = Y.PRODUCT.TYPE
    END

    SEL.CNT -= 1

    IF SEL.CNT NE 0 THEN
        RETURN
    END
    Y.CLOSE.AVG.TIME = Y.DIF.DATE/FLG
    PERCEN.CLOSE.TIME = (FLG.ON/FLG) * 100
    FLG = 0 ; Y.DIF.DATE = 0; FLG.ON = 0
    LOCATE Y.MON IN Y.STORE.MN SETTING POS.STORE.1 THEN
        Y.FIN.ARR.1<POS.STORE.1,-1> = FMT(SEG.DAYS,'L#40'):FMT(Y.CLOSE.AVG.TIME,'L#40'):FMT(PERCEN.CLOSE.TIME,'L2#40')
        Y.AVG.TOT<POS.STORE.1,-1> = FMT(SEG.DAYS,'L#40'):@SM:FMT(Y.CLOSE.AVG.TIME,'L#40'):@SM:FMT(PERCEN.CLOSE.TIME,'L2#40')
    END
    Y.MY.PUR<-1> = Y.MON
    Y.CNT.MY.PUR = DCOUNT(Y.STORE.MN,@FM)
    FL = 0
    LOOP
    WHILE Y.CNT.MY.PUR GT 0 DO
        FL += 1
        LOCATE Y.STORE.MN<FL> IN Y.MY.PUR SETTING POS.MY ELSE
            Y.FIN.ARR.1<FL,-1> = FMT(0,'L#40'):FMT(0,'L#40'):FMT(0,'L2#40')
            Y.AVG.TOT<FL,-1> = FMT(0,'L#40'):FMT(0,'L#40'):FMT(0,'L2#40')
        END
        Y.CNT.MY.PUR -= 1
    REPEAT

    Y.FIN.ARR.1 = CHANGE(Y.FIN.ARR.1,@FM,'')
    Y.FIN.ARR<-1> = FMT(Y.PRODUCT.TYPE,'L#40'):Y.FIN.ARR.1
    Y.AVG.TOT = CHANGE(Y.AVG.TOT,@FM,@VM)
    Y.AVG.TOT.FIN<-1> = Y.AVG.TOT
RETURN
************
SUB.FLAG.SET:
************
    IF FLG.1 NE 'SET' THEN
        RETURN
    END
    Y.CLOSE.AVG.TIME = Y.DIF.DATE/FLG
    PERCEN.CLOSE.TIME = (FLG.ON/FLG) * 100
    LOCATE Y.DUP.MON IN Y.STORE.MN SETTING POS.STRE THEN
        Y.FIN.ARR.1<POS.STRE,-1> = FMT(SEG.DAYS,'L#40'):FMT(Y.CLOSE.AVG.TIME,'L#40'):FMT(PERCEN.CLOSE.TIME,'L2#40')
        Y.AVG.TOT<POS.STRE,-1>  = FMT(SEG.DAYS,'L#40'):@SM:FMT(Y.CLOSE.AVG.TIME,'L#40'):@SM:FMT(PERCEN.CLOSE.TIME,'L2#40')
        Y.MY.PUR<-1> = Y.DUP.MON
        Y.CNT.MY.PUR = DCOUNT(Y.STORE.MN,@FM)
        FL = 0
        LOOP
        WHILE Y.CNT.MY.PUR GT 0 DO
            FL += 1
            LOCATE Y.STORE.MN<FL> IN Y.MY.PUR SETTING POS.MY ELSE
                Y.FIN.ARR.1<FL,-1> = FMT(0,'L#40'):FMT(0,'L#40'):FMT(0,'L2#40')
                Y.AVG.TOT<FL,-1> = FMT(0,'L#40'):@SM:FMT(0,'L#40'):@SM:FMT(0,'L2#40')
            END
            Y.CNT.MY.PUR -= 1
        REPEAT
        Y.FIN.ARR.1 = CHANGE(Y.FIN.ARR.1,@FM,'')
        Y.FIN.ARR<-1> = FMT(Y.DUP.PROD.TYPE,'L#40'):Y.FIN.ARR.1
        Y.AVG.TOT = CHANGE(Y.AVG.TOT,@FM,@VM)
        Y.AVG.TOT.FIN<-1> = Y.AVG.TOT
        Y.DIF.DATE = 0; FLG.ON = 0; Y.FIN.ARR.1 = ''; SEG.DAYS = ''; Y.AVG.TOT = ''; Y.MY.PUR = ''
    END
RETURN

************
FLAG.NOT.SET:
************
    IF FLG.TTS EQ 1 AND FLG.1 NE 'SET' ELSE
        RETURN
    END
    Y.CLOSE.AVG.TIME = Y.DIF.DATE/FLG
    PERCEN.CLOSE.TIME = (FLG.ON/FLG) * 100
    LOCATE Y.DUP.MON IN Y.STORE.MN SETTING POS.STRE THEN
        Y.FIN.ARR.1<POS.STRE,-1> = FMT(SEG.DAYS,'L#40'):FMT(Y.CLOSE.AVG.TIME,'L#40'):FMT(PERCEN.CLOSE.TIME,'L2#40')
        Y.AVG.TOT<POS.STRE,-1>  = FMT(SEG.DAYS,'L#40'):@SM:FMT(Y.CLOSE.AVG.TIME,'L#40'):@SM:FMT(PERCEN.CLOSE.TIME,'L2#40')
        Y.MY.PUR<-1> = Y.DUP.MON
        Y.CNT.MY.PUR = DCOUNT(Y.STORE.MN,@FM)
        FL = 0
        LOOP
        WHILE Y.CNT.MY.PUR GT 0 DO
            FL += 1
            LOCATE Y.STORE.MN<FL> IN Y.MY.PUR SETTING POS.MY ELSE
                Y.FIN.ARR.1<FL,-1> = FMT(0,'L#40'):FMT(0,'L#40'):FMT(0,'L2#40')
                Y.AVG.TOT<FL,-1> = FMT(0,'L#40'):@SM:FMT(0,'L#40'):@SM:FMT(0,'L2#40')
            END
            Y.CNT.MY.PUR -= 1
        REPEAT
        Y.FIN.ARR.1 = CHANGE(Y.FIN.ARR.1,@FM,'')
        Y.FIN.ARR<-1> = FMT(Y.DUP.PROD.TYPE,'L#40'):Y.FIN.ARR.1
        Y.AVG.TOT = CHANGE(Y.AVG.TOT,@FM,@VM)
        Y.AVG.TOT.FIN<-1> = Y.AVG.TOT
        Y.DIF.DATE = 0; FLG.ON = 0; FLG.1 = ''; Y.FIN.ARR.1 = ''; SEG.DAYS = ''; Y.AVG.TOT = ''; Y.MY.PUR = ''
    END
RETURN

*--------------
SLA.PARAM:
*--------------
* CALL F.READ(FN.REDO.SLA.PARAM,SLA.ID,R.REDO.SLA.PARAM,F.REDO.SLA.PARAM,REDO.SLA.PARAM.ERR)
    CALL CACHE.READ(FN.REDO.SLA.PARAM,SLA.ID,R.REDO.SLA.PARAM,REDO.SLA.PARAM.ERR) ;*Manual R22 Conversion
    SUPGRP = R.REDO.SLA.PARAM<SLA.SUPPORT.GROUP>
    LOCATE Y.SUPPORT.GROUP IN SUPGRP<1,1> SETTING SUP.POS THEN
        Y.SEG = R.REDO.SLA.PARAM<SLA.START.CHANNEL,SUP.POS>
        LOCATE Y.START.CHANNEL IN Y.SEG<1,1,1> SETTING SEG.POS THEN
            SEG.DAYS = R.REDO.SLA.PARAM<SLA.SEG.DAYS,SUP.POS,SEG.POS>
        END
    END
RETURN
END
