* @ValidationCode : Mjo3Mzg1NjA3NzA6Q3AxMjUyOjE2ODQ0OTEwMzI0MDQ6SVRTUzotMTotMToxMTk1OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1195
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION         FM TO @FM, VM TO @VM, SM TO @SM,++ TO +=, I TO I.VAR
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.E.APAP.NOF.CRM.REPORT(Y.DATA)
*----------------------------------------------------------------------------------------
*Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By  : Temenos Application Management
*Program Name  : REDO.E.APAP.NOF.CRM.REPORT
*----------------------------------------------------------------------------------------
*Description   : This is a no file enquiry routine for display COB REPORT ON "Statistics of Cases
*                or Opened Interactions by Detail and Product"
*Linked With   : Enquiry REDO.STATISTICS.CRM.REPORT
*In Parameter  : N/A
*Out Parameter : Y.DATA
*----------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*   Date             Who                  Reference               Description
*----------------------------------------------------------------------------------------
*  23rd SEP 2010    BHARATH G             ODR-2010-03-0113         Initial Creation
*  06 May 2015      Ashokkumar            PACS00347854             Fixed the report layout with values.
*----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.STANDARD.SELECTION
    $INSERT I_F.REDO.ISSUE.CLAIMS
    $INSERT I_F.REDO.U.CRM.PRODUCT.TYPE
    $INSERT I_F.EB.LOOKUP
*----------------------------------------------------------------------------------------
*

    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB GET.SEL.FLD.VALUE
    GOSUB GET.VALUES.FROM.SS
    GOSUB PROCESS

RETURN
*----------------------------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------------------------
* Initialise all the required Variables
*
    Y.TEMP.TOTAL.PERCENT = ''  ; Y.PRODUCT.VALUE = ''
    Y.CASE.STATUS.VALUE = ''   ; Y.INPUTTER.1.VALUE = ''
    Y.SUPPORT.GROUP.VALUE = '' ; Y.OPENING.CHANNEL.VALUE = ''
    Y.TYPE.VALUE = ''          ; Y.SUPPORT.GROUP.VAL = ''
    Y.OPEN.CHNL.VAL = ''       ; Y.PERCENT.COUNT = ''
    FORM.MONTH.ARRAY = ''      ; Y.TEMP.PERCENT = ''
    MONTH.ARRAY = ''           ; Y.MONTH.RANGE.VAL = ''
    MONTH.COUNT = ''           ; Y.PRD.TYPE.VAL = ''
    Y.STATUS.VAL = ''          ; MONTH.DIFF = '6'
    Y.MONTH.COUNT = ''         ; Y.TEMP.PRODUCT = ''
    Y.TEMP.STATUS = ''         ; Y.TEMP.MONTH = ''
    STATUS.POS = ''            ; MONTH.CUR.VAL = ''
    Y.TEMP.TOTAL = ''          ; Y.TOTAL.FINAL = ''
    Y.TOTAL.PERCENT = ''       ; Y.TEMP.TOTAL.MONTH.PERCENT = ''
    Y.MONTH.VAL = ''
RETURN
*----------------------------------------------------------------------------------------
OPEN.FILES:
*----------------------------------------------------------------------------------------
* Open all the required files
*
    FN.STANDARD.SELECTION = "F.STANDARD.SELECTION"
    F.STANDARD.SELECTION = ''
    CALL OPF(FN.STANDARD.SELECTION, F.STANDARD.SELECTION)

    FN.REDO.ISSUE.CLAIMS = "F.REDO.ISSUE.CLAIMS"
    F.REDO.ISSUE.CLAIMS = ''
    CALL OPF(FN.REDO.ISSUE.CLAIMS,F.REDO.ISSUE.CLAIMS)

    FN.REDO.U.CRM.PRODUCT.TYPE = 'F.REDO.U.CRM.PRODUCT.TYPE'
    F.REDO.U.CRM.PRODUCT.TYPE = ''
    CALL OPF(FN.REDO.U.CRM.PRODUCT.TYPE,F.REDO.U.CRM.PRODUCT.TYPE)

    FN.EB.LOOKUP = 'F.EB.LOOKUP'; F.EB.LOOKUP = ''
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)

    FORM.MONTH.ARRAY = '01':@FM:'02':@FM:'03':@FM:'04':@FM:'05':@FM:'06':@FM:'07':@FM:'08':@FM:'09':@FM:'10':@FM:'11':@FM:'12'
    SEL.CMD = 'SELECT ':FN.REDO.ISSUE.CLAIMS:" WITH @ID NE ''"
    Y.DATA.FILE.NAME = "REDO.ISSUE.CLAIMS"

RETURN
*----------------------------------------------------------------------------------------
GET.SEL.FLD.VALUE:
*----------------------------------------------------------------------------------------
*  Locate the selection Fields in D.FIELDS common variable and get the corresponding value
*  in D.RANGE.AND.VALUE. Ammend the select command accordingly
*
    LOCATE "PRODUCT" IN D.FIELDS<1> SETTING PRODUCT.POS THEN
        Y.PRODUCT.VALUE = D.RANGE.AND.VALUE<PRODUCT.POS>
        CHANGE @SM TO ' ' IN Y.PRODUCT.VALUE
        SEL.CMD := " AND PRODUCT.TYPE EQ ":Y.PRODUCT.VALUE
    END

    LOCATE "CASE.STATUS" IN D.FIELDS<1> SETTING CASE.STATUS.POS THEN
        Y.CASE.STATUS.VALUE = D.RANGE.AND.VALUE<CASE.STATUS.POS>
        CHANGE @SM TO ' ' IN Y.CASE.STATUS.VALUE
        SEL.CMD := " AND STATUS EQ "
        SEL.CMD :=  '"':Y.CASE.STATUS.VALUE:'"'
    END

    LOCATE "INPUTTER.1" IN D.FIELDS<1> SETTING INPUTTER.1.POS THEN
        Y.INPUTTER.1.VALUE = D.RANGE.AND.VALUE<INPUTTER.1.POS>
        CHANGE @SM TO ' ' IN Y.INPUTTER.1.VALUE
        SEL.CMD := " AND INPUTTER LIKE ..._":Y.INPUTTER.1.VALUE:"_..."
    END

    LOCATE "SUPPORT.GROUP" IN D.FIELDS<1> SETTING SUPPORT.GROUP.POS THEN
        Y.SUPPORT.GROUP.VALUE = D.RANGE.AND.VALUE<SUPPORT.GROUP.POS>
        CHANGE @SM TO ' ' IN Y.SUPPORT.GROUP.VALUE
        SEL.CMD := " AND SUPPORT.GROUP EQ "
        SEL.CMD :=  '"':Y.SUPPORT.GROUP.VALUE:'"'
    END

    LOCATE "OPENING.CHANNEL" IN D.FIELDS<1> SETTING OPENING.CHANNEL.POS THEN
        Y.OPENING.CHANNEL.VALUE = D.RANGE.AND.VALUE<OPENING.CHANNEL.POS>
        CHANGE @SM TO ' ' IN Y.OPENING.CHANNEL.VALUE
        SEL.CMD := " AND OPENING.CHANNEL EQ "
        SEL.CMD :=  '"':Y.OPENING.CHANNEL.VALUE:'"'
    END

    LOCATE "TYPE" IN D.FIELDS<1> SETTING TYPE.POS THEN
        Y.TYPE.VALUE = D.RANGE.AND.VALUE<TYPE.POS>
        CHANGE @SM TO ' ' IN Y.TYPE.VALUE
        SEL.CMD := " AND TYPE EQ "
        SEL.CMD :=  '"':Y.TYPE.VALUE:'"'
    END

    LOCATE "MONTH.OPEN.CASE" IN D.FIELDS<1> SETTING MONTH.POS THEN
        Y.MONTH.VAL = D.RANGE.AND.VALUE<MONTH.POS>
        CHANGE @SM TO @FM IN Y.MONTH.VAL
    END
RETURN
*----------------------------------------------------------------------------------------
GET.VALUES.FROM.SS:
*----------------------------------------------------------------------------------------
* Get the values from Selection Fields for the field PRODUCT & CASE.STATUS
*
    CALL GET.STANDARD.SELECTION.DETS(Y.DATA.FILE.NAME,R.SS)
    Y.SYS.FIELD.NAME = R.SS<SSL.SYS.FIELD.NAME>
    Y.SYS.VAL.PROG   = R.SS<SSL.SYS.VAL.PROG>

    Y.EL.ID = "CM.STATUS"
    SEL.EL = "SSELECT ":FN.EB.LOOKUP:" LIKE ":Y.EL.ID:"..."
    CALL EB.READLIST(SEL.EL,SEL.LISTEL,'',NO.OF.RECEL,SELEL.ERR)
    Y.TEMP.STATUS = ''; YGRP.STAT = 0; TOTAL.VAL.CASE = '0'
    SEL.PRD = ''; SEL.LISTP = ''; NO.OF.RECP = ''; SELP.ERR = ''
    SEL.PRD = "SSELECT ":FN.REDO.U.CRM.PRODUCT.TYPE
    CALL EB.READLIST(SEL.PRD,SEL.LISTP,'',NO.OF.RECP,SELP.ERR)
    LOOP
        REMOVE SEL.ID FROM SEL.LISTP SETTING POSN
    WHILE SEL.ID:POSN
        GOSUB READ.CRM.PRD.TYPE
        YTEMP.CNT = 0; YZERO = '0'; YGRP.STAT += 1 ;*AUTO R22 CODE CONVERSION
        GOSUB PROCESS.LOOKUP
    REPEAT
    GOSUB GET.VALUES.FROM.SS.1
RETURN

PROCESS.LOOKUP:
***************
    LOOP
    UNTIL NO.OF.RECEL EQ YTEMP.CNT
        YTEMP.CNT += 1 ;*AUTO R22 CODE CONVERSION
        YSTATUS.VAL = SEL.LISTEL<YTEMP.CNT>
        GOSUB READ.EB.LOOKUP
        IF YGRP.STAT EQ 1 THEN
            Y.TEMP.STATUS<-1> = YSTAT.LOOKUP
        END
        YRDCP.DESC.1 = ''
        YRDCP.DESC.1 = YRDCP.DESC:' ':YSTAT.LOOKUP
        IF YTEMP.CNT EQ 1 THEN
            YTK.DATA<-1> = YRDCP.DESC.1:",":YRDCP.DESC:",":YSTAT.LOOKUP:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE
        END ELSE
            YTK.DATA<-1> = YRDCP.DESC.1:",,":YSTAT.LOOKUP:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE:",":TOTAL.VAL.CASE
        END
    REPEAT
RETURN

GET.VALUES.FROM.SS.1:
********************
    CHANGE ',' TO @VM IN YTK.DATA
    LOCATE "SUPPORT.GROUP" IN Y.SYS.FIELD.NAME<1,1> SETTING SS.POS THEN
        GOSUB EXTRACT.STANDARD.SELECTION.VALUES
        Y.SUPPORT.GROUP.VAL = Y.SYS.VAL.PRG.OUT
    END

    LOCATE "OPENING.CHANNEL" IN Y.SYS.FIELD.NAME<1,1> SETTING SS.POS THEN
        GOSUB EXTRACT.STANDARD.SELECTION.VALUES
        Y.OPEN.CHANNEL.VAL = Y.SYS.VAL.PRG.OUT
    END
RETURN
*----------------------------------------------------------------------------------------
EXTRACT.STANDARD.SELECTION.VALUES:
*----------------------------------------------------------------------------------------
    Y.SYS.VAL.PRG.OUT = ''
    Y.SYS.VAL.PRG = Y.SYS.VAL.PROG<1,SS.POS>
    Y.TOTAL.SYS.VAL.PRG = DCOUNT(Y.SYS.VAL.PRG,"_")
    Y.SYS.VAL.PRG = FIELD(Y.SYS.VAL.PRG,"&",2)
    Y.SYS.VAL.PRG = FIELD(Y.SYS.VAL.PRG,"&",1)
    FOR I.VAR = 1 TO Y.TOTAL.SYS.VAL.PRG ;*AUTO R22 CODE CONVERSION
        Y.SYS.VAL.PRG.OUT<-1> = FIELDS(Y.SYS.VAL.PRG,"_",I.VAR,1)
    NEXT I.VAR
RETURN
*----------------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------------
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
    LOOP
        REMOVE Y.ID FROM SEL.LIST SETTING ISS.POS
    WHILE Y.ID:ISS.POS
        R.REDO.ISSUE.CLAIMS = ''; ISS.ERR = ''; YGRP.RIC = ''
        CALL F.READ(FN.REDO.ISSUE.CLAIMS,Y.ID,R.REDO.ISSUE.CLAIMS,F.REDO.ISSUE.CLAIMS,ISS.ERR)
        IF NOT(R.REDO.ISSUE.CLAIMS) THEN
            CONTINUE
        END
        SEL.ID = R.REDO.ISSUE.CLAIMS<ISS.CL.PRODUCT.TYPE>
        GOSUB READ.CRM.PRD.TYPE
        Y.STATUS        = R.REDO.ISSUE.CLAIMS<ISS.CL.STATUS>
        YSTATUS.VAL = Y.EL.ID:'*':Y.STATUS
        GOSUB READ.EB.LOOKUP
        Y.OPEN.DATE     = R.REDO.ISSUE.CLAIMS<ISS.CL.OPENING.DATE>
        Y.OPENING.MONTH = Y.OPEN.DATE[5,2]
        YGRP.RIC = YRDCP.DESC:' ':YSTAT.LOOKUP
        IF Y.MONTH.VAL THEN
            LOCATE Y.OPENING.MONTH IN Y.MONTH.VAL<1> SETTING OM.POSN ELSE
                CONTINUE
            END
        END
        GOSUB MONTH.CHK
        GOSUB ASSIGN.MONTH
    REPEAT
    GOSUB COUNT.TOTAL.IN.EACH.STATUS
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

READ.CRM.PRD.TYPE:
******************
    REC.REDO.U.CRM.PRODUCT.TYPE = ''; RUCP.ERR = ''; YRDCP.DESC = ''
    CALL F.READ(FN.REDO.U.CRM.PRODUCT.TYPE,SEL.ID,REC.REDO.U.CRM.PRODUCT.TYPE,F.REDO.U.CRM.PRODUCT.TYPE,RUCP.ERR)
    YRDCP.DESC = REC.REDO.U.CRM.PRODUCT.TYPE<PRD.TYPE.DESCRIPTION>
RETURN

MONTH.CHK:
**********
    YCASE.NO = ''
    IF Y.OPENING.MONTH EQ '01' THEN
        Y.OPENING.MONTH = 'Mes1'
        YCASE.NO = 4
    END
    IF Y.OPENING.MONTH EQ '02' THEN
        Y.OPENING.MONTH = 'Mes2'
        YCASE.NO = 6
    END
    IF Y.OPENING.MONTH EQ '03' THEN
        Y.OPENING.MONTH = 'Mes3'
        YCASE.NO = 8
    END
    IF Y.OPENING.MONTH EQ '04' THEN
        Y.OPENING.MONTH = 'Mes4'
        YCASE.NO = 10
    END
    IF Y.OPENING.MONTH EQ '05' THEN
        Y.OPENING.MONTH = 'Mes5'
        YCASE.NO = 12
    END
    IF Y.OPENING.MONTH EQ '06' THEN
        Y.OPENING.MONTH = 'Mes6'
        YCASE.NO = 14
    END
    IF Y.OPENING.MONTH EQ '07' THEN
        Y.OPENING.MONTH = 'Mes7'
        YCASE.NO = 16
    END
    GOSUB MONTH.CHK.1
RETURN

MONTH.CHK.1:
************
    IF Y.OPENING.MONTH EQ '08' THEN
        Y.OPENING.MONTH = 'Mes8'
        YCASE.NO = 18
    END
    IF Y.OPENING.MONTH EQ '09' THEN
        Y.OPENING.MONTH = 'Mes9'
        YCASE.NO = 20
    END
    IF Y.OPENING.MONTH EQ '10' THEN
        Y.OPENING.MONTH = 'Mes10'
        YCASE.NO = 22
    END
    IF Y.OPENING.MONTH EQ '11' THEN
        Y.OPENING.MONTH = 'Mes11'
        YCASE.NO = 24
    END
    IF Y.OPENING.MONTH EQ '12' THEN
        Y.OPENING.MONTH = 'Mes12'
        YCASE.NO = 26
    END
RETURN

ASSIGN.MONTH:
*----------------------------------------------------------------------------------------
    FINDSTR YGRP.RIC IN YTK.DATA SETTING PRD.POS,PRD.VM,PRD.SM THEN
        YTK.DATA<PRD.POS,YCASE.NO> += 1
    END
RETURN

COUNT.TOTAL.IN.EACH.STATUS:
*----------------------------------------------------------------------------------------
*
    Y001.VAL = "0%"; Y002.VAL = "0%"; Y003.VAL = "0%"; Y004.VAL = "0%"; Y005.VAL = "0%"; Y006.VAL = "0%"; YSTATS.VAL = ''
    Y007.VAL = "0%"; Y008.VAL = "0%"; Y009.VAL = "0%"; Y010.VAL = "0%"; Y011.VAL = "0%"; Y012.VAL = "0%"; YPRD.VAL = ''

    Y.DATA = "*":FMT('Apertura caso mes','R#27'):"*":FMT('Mes1','R#22'):FMT('Mes2','R#22'):FMT('Mes3','R#22'):FMT('Mes4','R#22'):FMT('Mes5','R#22'):FMT('Mes6','R#22'):FMT('Mes7','R#22'):FMT('Mes8','R#22'):FMT('Mes9','R#22'):FMT('Mes10','R#22'):FMT('Mes11','R#22'):FMT('Mes12','R#22'):FMT('Total','R#22')
    Y.DATA<-1> = FMT('Producto','R#15'):"*":FMT('Caso interaction status','R#27'):"*":FMT('Numero de caso','R#15'):FMT('caso %','R#7'):FMT('Numero de caso','R#15'):FMT('caso %','R#7'):FMT('Numero de caso','R#15'):FMT('caso %','R#7'):FMT('Numero de caso','R#15'):FMT('caso %','R#7'):FMT('Numero de caso','R#15'):FMT('caso %','R#7'):FMT('Numero de caso','R#15'):FMT('caso %','R#7'):FMT('Numero de caso','R#15'):FMT('caso %','R#7'):FMT('Numero de caso','R#15'):FMT('caso %','R#7'):FMT('Numero de caso','R#15'):FMT('caso %','R#7'):FMT('Numero de caso','R#15'):FMT('caso %','R#7'):FMT('Numero de caso','R#15'):FMT('caso %','R#7'):FMT('Numero de caso','R#15'):FMT('caso %','R#7'):FMT('Total caso','R#15'):FMT('caso %','R#7')

    TOT.NO.OF.PRODUCT = DCOUNT(YTK.DATA,@FM)
    FOR I.VALUE = 1 TO TOT.NO.OF.PRODUCT
        YGRP.VAL = YTK.DATA<I.VALUE>
        YGRP.FLG = 0
        GOSUB STAT.FIELD.VALUES

        YTOT.VAL = Y01.VAL + Y02.VAL + Y03.VAL + Y04.VAL + Y05.VAL + Y06.VAL + Y07.VAL + Y08.VAL + Y09.VAL + Y10.VAL + Y11.VAL + Y12.VAL
        GOSUB STAT.FIELD.VALUE.1

        Y.DATA<-1> = FMT(YPRD.VAL,"R#15"):"*":FMT(YSTATS.VAL,"R#27"):"*":FMT(Y01.VAL,"R#15"):FMT(Y001.VAL,"R#6"):"%":FMT(Y02.VAL,"R#15"):FMT(Y002.VAL,"R#6"):"%":FMT(Y03.VAL,"R#15"):FMT(Y003.VAL,"R#6"):"%":FMT(Y04.VAL,"R#15"):FMT(Y004.VAL,"R#6"):"%":FMT(Y05.VAL,"R#15"):FMT(Y005.VAL,"R#6"):"%":FMT(Y06.VAL,"R#15"):FMT(Y006.VAL,"R#6"):"%":FMT(Y07.VAL,"R#15"):FMT(Y007.VAL,"R#6"):"%":FMT(Y08.VAL,"R#15"):FMT(Y008.VAL,"R#6"):"%":FMT(Y09.VAL,"R#15"):FMT(Y009.VAL,"R#6"):"%":FMT(Y10.VAL,"R#15"):FMT(Y010.VAL,"R#6"):"%":FMT(Y11.VAL,"R#15"):FMT(Y011.VAL,"R#6"):"%":FMT(Y12.VAL,"R#15"):FMT(Y012.VAL,"R#6"):"%":FMT(YTOT.VAL,"R#15"):FMT(YTOT.PER,"R#6"):"%"
    NEXT I.VALUE
RETURN

STAT.FIELD.VALUES:
******************
    YPRD.VAL = FIELD(YGRP.VAL,@VM,2)
    YSTATS.VAL = FIELD(YGRP.VAL,@VM,3)
    Y01.VAL = FIELD(YGRP.VAL,@VM,4)
    Y02.VAL = FIELD(YGRP.VAL,@VM,6)
    Y03.VAL = FIELD(YGRP.VAL,@VM,8)
    Y04.VAL = FIELD(YGRP.VAL,@VM,10)
    Y05.VAL = FIELD(YGRP.VAL,@VM,12)
    Y06.VAL = FIELD(YGRP.VAL,@VM,14)
    Y07.VAL = FIELD(YGRP.VAL,@VM,16)
    Y08.VAL = FIELD(YGRP.VAL,@VM,18)
    Y09.VAL = FIELD(YGRP.VAL,@VM,20)
    Y10.VAL = FIELD(YGRP.VAL,@VM,22)
    Y11.VAL = FIELD(YGRP.VAL,@VM,24)
    Y12.VAL = FIELD(YGRP.VAL,@VM,26)
    Y001.VAL = FIELD(YGRP.VAL,@VM,5)
    Y002.VAL = FIELD(YGRP.VAL,@VM,7)
    Y003.VAL = FIELD(YGRP.VAL,@VM,9)
    Y004.VAL = FIELD(YGRP.VAL,@VM,11)
    Y005.VAL = FIELD(YGRP.VAL,@VM,13)
    Y006.VAL = FIELD(YGRP.VAL,@VM,15)
    Y007.VAL = FIELD(YGRP.VAL,@VM,17)
    Y008.VAL = FIELD(YGRP.VAL,@VM,19)
    Y009.VAL = FIELD(YGRP.VAL,@VM,21)
    Y010.VAL = FIELD(YGRP.VAL,@VM,23)
    Y011.VAL = FIELD(YGRP.VAL,@VM,25)
    Y012.VAL = FIELD(YGRP.VAL,@VM,27)
RETURN

STAT.FIELD.VALUE.1:
*******************
    IF Y01.VAL NE 0 THEN
        Y001.VAL = (Y01.VAL / YTOT.VAL) * 100
        YGRP.FLG = 1
    END
    IF Y02.VAL NE 0 THEN
        Y002.VAL = (Y02.VAL / YTOT.VAL) * 100
        YGRP.FLG = 1
    END
    IF Y03.VAL NE 0 THEN
        Y003.VAL = (Y03.VAL / YTOT.VAL) * 100
        YGRP.FLG = 1
    END
    IF Y04.VAL NE 0 THEN
        Y004.VAL = (Y04.VAL / YTOT.VAL) * 100
        YGRP.FLG = 1
    END
    IF Y05.VAL NE 0 THEN
        Y005.VAL = (Y05.VAL / YTOT.VAL) * 100
        YGRP.FLG = 1
    END
    IF Y06.VAL NE 0 THEN
        Y006.VAL = (Y06.VAL / YTOT.VAL) * 100
        YGRP.FLG = 1
    END
    IF Y07.VAL NE 0 THEN
        Y007.VAL = (Y07.VAL / YTOT.VAL) * 100
        YGRP.FLG = 1
    END
    IF Y08.VAL NE 0 THEN
        Y008.VAL = (Y08.VAL / YTOT.VAL) * 100
        YGRP.FLG = 1
    END
    IF Y09.VAL NE 0 THEN
        Y009.VAL = (Y09.VAL / YTOT.VAL) * 100
        YGRP.FLG = 1
    END
    IF Y10.VAL NE 0 THEN
        Y010.VAL = (Y10.VAL / YTOT.VAL) * 100
        YGRP.FLG = 1
    END
    IF Y11.VAL NE 0 THEN
        Y011.VAL = (Y11.VAL / YTOT.VAL) * 100
        YGRP.FLG = 1
    END
    IF Y12.VAL NE 0 THEN
        Y012.VAL = (Y12.VAL / YTOT.VAL) * 100
        YGRP.FLG = 1
    END

    IF YGRP.FLG EQ 1 THEN
        YTOT.PER = "100.00"
    END ELSE
        YTOT.PER = "0.00"
    END
RETURN
END
