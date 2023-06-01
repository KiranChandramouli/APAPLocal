* @ValidationCode : MjozMDgxNzM5ODQ6Q3AxMjUyOjE2ODQ4MzYwNTIyMzM6SVRTUzotMTotMToxMDYyOjE6ZmFsc2U6Ti9BOlIyMl9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:52
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1062
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.SAC.SNO.ASSN.MOD(Y.OUT.ARRAY)
*----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.SAC.SNO.ASSN.MOD
*----------------------------------------------------------------------------
*Description  : REDO.APAP.NOF.VIRGIN.DAMAGE is the Nofile Enquiry routine
*This routine is used to build data for Enquiry Display from REDO.H.REASSIGNMENT
*Attached to  : Standard Selection For the Enquiry REDO.APAP.NOF.SAV.AC.SNO.ASSIGN.MOD
*In Parameter : N/A
*Out Parameter: Y.OUT.ARRAY
*----------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 22 DEC 2010    Anuha@Contractor      ODR-2010-03-0136        Initial Creation
* 25 MAR 2013  Vignesh Kumaar M R      PACS00256405            Additional fix for date format
* 15 JUL 2014   Ajish@Capgemini        PACS00312311            Fix for the field CONCEPTO ASIG. SERIE
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*18-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  FM to @FM , VM to @VM , SM to @SM
*18-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.USER
    $INSERT I_F.CATEGORY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.COMPANY
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.REDO.H.REASSIGNMENT
    $INSERT I_F.REDO.H.PASSBOOK.INVENTORY
	$USING APAP.REDOEB
 

MAIN.PARA:
*=========
    GOSUB OPEN.FILES
    GOSUB CHECK.SELECTION
    IF SEL.LIST THEN
        GOSUB PROCESS
    END
    IF R.ASSIG.ID.LIST THEN
        GOSUB ASSIG.ID.PROCESS
    END

RETURN

CHECK.SELECTION:
*===============

    Y.AGENCY = '' ; Y.OUT.ARRAY = '' ; Y.SEL.DISP = '' ; Y.SORT.LIST = ''
    Y.NSER.CT = ''
    Y.NSERT.CT = ''
    Y.NEW.SER.CNT = ''
    Y.FLAG1 = @FALSE
    Y.SEL.DISP.1 = '' ; Y.SEL.DISP.2 = ''

    LOCATE 'AGENCY' IN D.FIELDS<1> SETTING Y.AGENCY.POS THEN
        Y.AGENCY = D.RANGE.AND.VALUE<Y.AGENCY.POS>
        Y.SEL.DISP := 'AGENCIA : ':Y.AGENCY:'; '
    END
    Y.ACCT.TYPE = ''
    LOCATE 'ACCOUNT.TYPE' IN D.FIELDS<1> SETTING Y.ACCT.TYPE.POS THEN
        Y.ACCT.TYPE = D.RANGE.AND.VALUE<Y.ACCT.TYPE.POS>
        Y.CATEG.ID = Y.ACCT.TYPE
        GOSUB GET.CATEG.DESC
        Y.SEL.DISP := " TIPO DE CUENTA : ":Y.ACCT.TYPE:'; '
    END
    IF D.FIELDS EQ 'Y.OUT.ARRAY' AND NOT(Y.SEL.DISP) THEN
        Y.SEL.DISP = 'TODOS ; '
    END

* For reassigned serial numbers
    SEL.CMD = "SELECT ":FN.REDO.H.REASSIGNMENT
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.CNT,SEL.ERR)

* For new assigned series and canceled series
    Y.SEL.STR = 'SELECT ':FN.REDO.H.PASSBOOK.INVENTORY:' WITH NEW.CREATED EQ YES'
    CALL EB.READLIST(Y.SEL.STR, R.ASSIG.ID.LIST, '','','')

    Y.SC.CNT = COUNT(Y.SEL.DISP, ';')
    Y.LAST.POS = INDEX(Y.SEL.DISP, ';', Y.SC.CNT)
    Y.SEL.DISP[Y.LAST.POS, 99] = ''

RETURN

OPEN.FILES:
*==========

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.COMPANY = "F.COMPANY"
    F.COMPANY = ''
    CALL OPF(FN.COMPANY,F.COMPANY)

    FN.REDO.H.PASSBOOK.INVENTORY = 'F.REDO.H.PASSBOOK.INVENTORY'
    F.REDO.H.PASSBOOK.INVENTORY = ''
    CALL OPF(FN.REDO.H.PASSBOOK.INVENTORY, F.REDO.H.PASSBOOK.INVENTORY)

    FN.CATEGORY = "F.CATEGORY"
    F.CATEGORY = ''
    CALL OPF(FN.CATEGORY,F.CATEGORY)

    FN.REDO.H.REASSIGNMENT = "F.REDO.H.REASSIGNMENT"
    F.REDO.H.REASSIGNMENT = ''
    CALL OPF(FN.REDO.H.REASSIGNMENT,F.REDO.H.REASSIGNMENT)

    FN.REDO.H.REASSIGNMENT$HIS = "F.REDO.H.REASSIGNMENT$HIS"
    F.REDO.H.REASSIGNMENT$HIS = ''
    CALL OPF(FN.REDO.H.REASSIGNMENT$HIS,F.REDO.H.REASSIGNMENT$HIS)

    FN.EB.LOOKUP = "F.EB.LOOKUP"
    F.EB.LOOKUP = ''

RETURN

READ.PREV.CURR.NO.RECORD:
*========================
    Y.TOT = ''
    IF R.RED.ASSN<RE.ASS.CURR.NO> GT 1 THEN
        Y.PREV.CURR.NO = R.RED.ASSN<RE.ASS.CURR.NO> - 1
        LOOP
        WHILE Y.PREV.CURR.NO GE 1
            Y.REDO.PREV.ID = Y.REDO.ID:";":Y.PREV.CURR.NO
            GOSUB READ.REASSIGN.TABLE.HIS

            Y.CHECK.VAL = R.REDO.PRE<RE.ASS.SERIES>
            IF Y.CHECK.VAL THEN
                Y.TOT<-1> = Y.CHECK.VAL
            END
            Y.PREV.SERIES<-1> = R.REDO.PRE<RE.ASS.SERIES>
            CHANGE @FM TO @VM IN Y.PREV.SERIES
            Y.PREV.DT.TIME<-1> = '20':R.REDO.PRE<RE.ASS.DATE.TIME>[1,6]
            Y.SR.COUNT = DCOUNT(R.REDO.PRE<RE.ASS.SERIES>,@VM)
            Y.SR.START = 1
            LOOP
            WHILE Y.SR.START LT Y.SR.COUNT
                Y.PREV.DT.TIME := @VM:''
                Y.SR.START += 1
            REPEAT
            Y.PREV.CURR.NO -= 1
        REPEAT
    END
********************************************
    V.GET.VAL = ''
    IF Y.PREV.SERIES NE '' THEN
        V.GET.VAL = Y.TOT
        CHANGE @FM TO @SM IN V.GET.VAL
        CHANGE @VM TO @SM IN V.GET.VAL
        Y.NSERT.CT = DCOUNT(V.GET.VAL,@SM)
    END


********************************************
    CHANGE @FM TO @VM IN Y.PREV.SERIES
    CHANGE @FM TO @VM IN Y.PREV.DT.TIME
RETURN

GET.CATEG.DESC:
*==============
    R.COM.REC = ''
    CALL CACHE.READ(FN.CATEGORY,Y.CATEG.ID,R.COM.REC,Y.COM.ERR)
    Y.CATEG.DESC = R.COM.REC<EB.CAT.DESCRIPTION, LNGG>

    IF Y.CATEG.DESC ELSE
        Y.CATEG.DESC = R.COM.REC<EB.CAT.DESCRIPTION, 1>
    END

    CHANGE '*' TO '' IN Y.CATEG.ID
RETURN

PROCESS:
*========
    FOR Y.REDO = 1 TO SEL.CNT
        Y.REDO.ID = SEL.LIST<Y.REDO> ; R.RED.ASSN = ''
        GOSUB READ.REASSIGN.TABLE

        Y.ACCT.NO = R.RED.ASSN<RE.ASS.ACCOUNT.NUMBER>
*
* Used Cache read for Account: Only Static info is required *
*
        GOSUB READ.ACCOUNT.TABLE

        Y.CATEG.ID = R.AC.REC<AC.CATEGORY>

        IF Y.ACCT.TYPE AND Y.ACCT.TYPE NE Y.CATEG.ID THEN
            CONTINUE
        END

        GOSUB GET.CATEG.DESC

        Y.EXE.AGENCY = R.RED.ASSN<RE.ASS.CO.CODE>
        GOSUB GET.SERIES.INFO

        Y.AC.AGENCY = R.AC.REC<AC.CO.CODE>

        IF Y.AGENCY AND Y.AGENCY NE Y.AC.AGENCY THEN
            CONTINUE
        END

        Y.OPEN.DATE = R.AC.REC<AC.OPENING.DATE>
        Y.AUTHORIZER = FIELD(R.RED.ASSN<RE.ASS.AUTHORISER>,'_',2)
        Y.INPUT = FIELD(R.RED.ASSN<RE.ASS.INPUTTER>,'_',2)
        Y.ACCT.NAME = Y.ACCT.NO

        Y.SERIAL.ASSIGN = R.RED.ASSN<RE.ASS.REASON.FOR.ASSN>
        GOSUB GET.LOOKUP.DESC

        GOSUB APPEND.OUTPUT.DATA

        GOSUB NULL.VALUES

    NEXT Y.REDO

RETURN

*----------------------------------------------------------------------------------------------------------------------
GET.SERIES.INFO:
*----------------------------------------------------------------------------------------------------------------------

* Fix for PACS00256405 [Additional fix for date format]
    Y.ASSIG.DATE = '20':R.RED.ASSN<RE.ASS.DATE.TIME>[1,6]
    Y.SERIAL.ASSIGN = R.RED.ASSN<RE.ASS.REASON.FOR.ASSN>
    GOSUB GET.LOOKUP.DESC

* End of Fix

    Y.SERIAL.NUM = R.RED.ASSN<RE.ASS.SERIES>

* Fix for PACS00256405 [Additional fix for date format]

    IF Y.SERIAL.NUM THEN
        GET.SER.CNT = Y.SERIAL.NUM
        CHANGE @FM TO @SM IN GET.SER.CNT
        CHANGE @VM TO @SM IN GET.SER.CNT
        Y.NEW.SER.CNT = DCOUNT(GET.SER.CNT,@SM)
    END ELSE
        Y.NEW.SER.CNT = ''
    END

* End of Fix

    Y.NEW.SERIES = R.RED.ASSN<RE.ASS.NEW.SERIES>
    IF Y.NEW.SERIES THEN
        Y.NSER.CT = 1
    END ELSE
        Y.NSER.CT = ''
    END
    Y.PREV.SERIES = '' ; Y.PREV.DT.TIME = ''

    IF Y.NEW.SERIES THEN
        GOSUB READ.PREV.CURR.NO.RECORD
    END

RETURN


GET.LOOKUP.DESC:
*===============*

    Y.LOOKUP.ID = "L.REASON.ASSING"
    Y.LOOKUP.VAL = Y.SERIAL.ASSIGN
    CALL APAP.REDOEB.redoEbLookupList(Y.LOOKUP.ID,Y.LOOKUP.VAL,Y.DESC.VAL,RES1,RES2)
    Y.SERIAL.ASSIGN = Y.DESC.VAL

RETURN
 
READ.ACCOUNT.TABLE:
*==================*

    CALL F.READ(FN.ACCOUNT,Y.ACCT.NO,R.AC.REC, F.ACCOUNT, Y.ERR)
RETURN

READ.REASSIGN.TABLE:
*===================*

    CALL F.READ(FN.REDO.H.REASSIGNMENT,Y.REDO.ID,R.RED.ASSN, F.REDO.H.REASSIGNMENT, Y.RED.ERROR)
RETURN

READ.REASSIGN.TABLE.HIS:
*=======================*

    CALL CACHE.READ(FN.REDO.H.REASSIGNMENT$HIS,Y.REDO.PREV.ID,R.REDO.PRE,Y.REDO.PRE.ERR)
RETURN


*AGENCY.PROCESS:
**==============*
*
*    CALL CACHE.READ(FN.COMPANY,Y.AGENCY,R.COM.REC,Y.COM.ERR)
*    Y.COMP.NAME.DESC = R.COM.REC<EB.COM.COMPANY.NAME, LNGG>
*
*    IF NOT(Y.COMP.NAME.DESC) THEN
*        Y.COMP.NAME.DESC = R.COM.REC<EB.COM.COMPANY.NAME, 1>
*    END
*
*    Y.SEL.DISP := " AGENCIA : ":Y.COMP.NAME.DESC:'; '
***
*    RETURN
*
APPEND.OUTPUT.DATA:
*=================
*    IF NOT(Y.FLAG1) AND Y.SEL.DISP EQ '' THEN
*        Y.SEL.DISP = 'TODO'
*        Y.FLAG1 = @TRUE
*    END

*    IF Y.SERIAL.NUM THEN
*        Y.SERIAL.NUM = FMT(Y.SERIAL.NUM, 'R%16')
*    END
*    IF Y.NEW.SERIES THEN
*        Y.NEW.SERIES = FMT(Y.NEW.SERIES, 'R%16')
*    END
*    IF Y.PREV.SERIES THEN
*        Y.PREV.SERIES = FMT(Y.PREV.SERIES, 'R%16')
*    END

    Y.SORT.ID = Y.EXE.AGENCY:Y.ASSIG.DATE:Y.CATEG.ID:"$":Y.NEW.SERIES:"$":Y.PREV.SERIES
    Y.OUT.ARRAY1 = Y.EXE.AGENCY:"$":Y.ASSIG.DATE:"$":Y.CATEG.DESC:"$"
    Y.OUT.ARRAY1:= Y.ACCT.NO:"$":Y.ACCT.NAME:"$":Y.AC.AGENCY:"$"
    Y.OUT.ARRAY1:= Y.SERIAL.ASSIGN:"$":Y.NEW.SERIES:"$":Y.SERIAL.NUM:"$"
    Y.OUT.ARRAY1:= Y.PREV.SERIES:"$":Y.PREV.DT.TIME:"$":Y.AUTHORIZER:"$"
    Y.OUT.ARRAY1:= Y.INPUT:"$":Y.NSER.CT:"$":Y.SEL.DISP:"$":Y.NSERT.CT:"$":Y.NEW.SER.CNT

    LOCATE Y.SORT.ID IN Y.SORT.LIST<1> BY 'AR' SETTING Y.BK.POS ELSE Y.FLAG = ''
    INS Y.SORT.ID BEFORE Y.SORT.LIST<Y.BK.POS>
    INS Y.OUT.ARRAY1 BEFORE Y.OUT.ARRAY<Y.BK.POS>
    Y.NSER.CT = ''
    Y.NSERT.CT = ''
    Y.NEW.SER.CNT = ''

RETURN
*---------------------
NULL.VALUES:
*-----------

    Y.EXE.AGENCY = ''
    Y.ASSIG.DATE = ''
    Y.CATEG.DESC = ''
    Y.ACCT.NO    = ''
    Y.ACCT.NAME  = ''
    Y.AC.AGENCY  = ''
    Y.SERIAL.ASSIGN = ''
    Y.SERIAL.NUM  = ''
    Y.NEW.SERIES  = ''
    Y.PREV.SERIES = ''
    Y.PREV.DT.TIME = ''
    Y.AUTHORIZER = ''
    Y.INPUT = ''
    Y.NSER.CT = ''
    Y.NSERT.CT = ''
    Y.NEW.SER.CNT = ''

RETURN
*---------------------
ASSIG.ID.PROCESS:
*------------------

    LOOP
        REMOVE Y.ASSIG.ID FROM R.ASSIG.ID.LIST SETTING Y.ASSIGN.POS
    WHILE Y.ASSIG.ID:Y.ASSIGN.POS

        Y.READ.ERR = ''
        R.ASSIG.RECORD = ''
        CALL F.READ(FN.REDO.H.PASSBOOK.INVENTORY, Y.ASSIG.ID, R.ASSIG.RECORD, F.REDO.H.PASSBOOK.INVENTORY, Y.READ.ERR)

        Y.EXE.AGENCY = R.ASSIG.RECORD<REDO.PASS.CO.CODE>
        Y.STATUS.CNT = DCOUNT(R.ASSIG.RECORD<REDO.PASS.STATUS.DATE> , @VM)
        Y.ASSIG.DATE = R.ASSIG.RECORD<REDO.PASS.STATUS.DATE, Y.STATUS.CNT>
        Y.ACCT.NO = R.ASSIG.RECORD<REDO.PASS.ACCOUNT>

        GOSUB READ.ACCOUNT.TABLE

        Y.CATEG.ID = R.ASSIG.RECORD<REDO.PASS.CATEGORY>

        IF Y.ACCT.TYPE AND Y.ACCT.TYPE NE Y.CATEG.ID THEN
            CONTINUE
        END

        GOSUB GET.CATEG.DESC


        Y.ACCT.NAME = Y.ACCT.NO
        Y.AC.AGENCY = R.AC.REC<AC.CO.CODE>

        IF Y.AGENCY AND Y.AGENCY NE Y.AC.AGENCY THEN
            CONTINUE
        END

        Y.OPEN.DATE = R.AC.REC<AC.OPENING.DATE>
        Y.SERIAL.ASSIGN = R.ASSIG.RECORD<REDO.PASS.STATUS>

        Y.SERIAL.NUM = R.ASSIG.RECORD<REDO.PASS.SERIAL.NO>
        Y.SERIAL.NO = Y.SERIAL.NUM
        Y.NEW.SERIES = ''
        Y.NSERT.CT = 1
        IF Y.SERIAL.ASSIGN EQ 'Cancelada' OR Y.SERIAL.ASSIGN EQ 'Destruida' THEN
            Y.PREV.SERIES = Y.SERIAL.NUM
            Y.PREV.DT.TIME = R.ASSIG.RECORD<REDO.PASS.STATUS.DATE, Y.STATUS.CNT>
            Y.SERIAL.NUM = ''
            Y.NEW.SER.CNT = 1
            Y.NSERT.CT = ''
        END

        GOSUB READ.REASSIGN
        GOSUB FORM.OUTPUT.ARR
        GOSUB NULL.VALUES

    REPEAT


RETURN

READ.REASSIGN:

* Fix for PACS00312311

    Y.LAN = R.USER<EB.USE.LANGUAGE>
    SEL.CMD = " SELECT ":FN.REDO.H.REASSIGNMENT:" WITH ACCOUNT.NUMBER EQ ":Y.ACCT.NAME: " AND WITH NEW.SERIES EQ ":Y.SERIAL.NO
    CALL EB.READLIST(SEL.CMD,SEL.LIST.ASSGN,'',NOF,ERR)
    Y.ID = SEL.LIST.ASSGN
    CALL F.READ(FN.REDO.H.REASSIGNMENT,Y.ID,R.REDO.H.REASSIGNMENT,F.REDO.H.REASSIGNMENT,ERR)
    Y.DESCRIP = R.REDO.H.REASSIGNMENT<RE.ASS.REASON.FOR.ASSN>
    IF Y.DESCRIP THEN
        Y.VAL = 'L.REASON.ASSING*':Y.DESCRIP
        CALL F.READ(FN.EB.LOOKUP,Y.VAL,R.EB,F.EB.LOOKUP,Y.ERR.EB)
        Y.SERIAL.ASSIGN = R.EB<EB.LU.DESCRIPTION,Y.LAN>
    END ELSE
        Y.SERIAL.ASSIGN = 'Apertura'
    END

* End of Fix - PACS00312311

RETURN

FORM.OUTPUT.ARR:

    Y.AUTHORIZER = R.ASSIG.RECORD<REDO.PASS.USER.AUTH, Y.STATUS.CNT>
    Y.INPUT = R.ASSIG.RECORD<REDO.PASS.USER.MOD, Y.STATUS.CNT>

    IF NOT(Y.AUTHORIZER) THEN
        Y.AUTHORIZER = FIELD(R.ASSIG.RECORD<REDO.PASS.INPUTTER>, '_', 2)
    END
    IF NOT(Y.INPUT) THEN
        Y.INPUT = FIELD(R.ASSIG.RECORD<REDO.PASS.AUTHORISER>, '_', 2)
    END

    Y.OUT.ARRAY1 = Y.EXE.AGENCY:"$":Y.ASSIG.DATE:"$":Y.CATEG.DESC:"$"
    Y.OUT.ARRAY1:= Y.ACCT.NO:"$":Y.ACCT.NAME:"$":Y.AC.AGENCY:"$"
    Y.OUT.ARRAY1:= Y.SERIAL.ASSIGN:"$":Y.SERIAL.NUM:"$":Y.NEW.SERIES:"$"
    Y.OUT.ARRAY1:= Y.PREV.SERIES:"$":Y.PREV.DT.TIME:"$":Y.AUTHORIZER:"$"
    Y.OUT.ARRAY1:= Y.INPUT:"$":Y.NSER.CT:"$":Y.SEL.DISP:"$":Y.NSERT.CT:"$":Y.NEW.SER.CNT

    Y.OUT.ARRAY<-1> = Y.OUT.ARRAY1

RETURN

*----------------------

END
