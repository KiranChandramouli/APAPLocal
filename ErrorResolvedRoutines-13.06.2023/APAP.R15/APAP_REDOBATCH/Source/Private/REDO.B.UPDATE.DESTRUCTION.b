* @ValidationCode : MjoyMDAyMDUxMzA2OkNwMTI1MjoxNjg0ODU0NDAxMDYzOklUU1M6LTE6LTE6MzU2OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 356
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.UPDATE.DESTRUCTION(Y.SE.SEL.LIST)
********************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Swaminathan.S.R
* PROGRAM NAME: REDO.B.UPDATE.DESTRUCTION
*------------------------------------------------------------------------------
*DESCRIPTION:This routine is COB routine to select all STOCK.ENTRY and calculate destruction date. Attach to D990 stage
*-------------------------------------------------------------------------------
*IN PARAMETER: NONE
*OUT PARAMETER: NONE
*LINKED WITH: REDO.B.UPDATE.DESTRUCTION
*-----------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE            DESCRIPTION
*31-07-2010    Swaminathan.S.R        ODR-2010-03-0400      INITIAL CREATION
*16 MAY 2011    JEEVA T               ODR-2010-03-0400      FIX FOR PACS00036010
* Date                   who                   Reference              
* 17-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - VM TO @VM AND TNO TO C$T24.SESSION.NO
* 17-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_BATCH.FILES
    $INSERT I_F.STOCK.ENTRY
    $INSERT I_F.DATES
    $INSERT I_F.USER
    $INSERT I_REDO.B.UPDATE.DESTRUCTION.COMMON
    $INSERT I_F.REDO.CARD.REQUEST
    $INSERT I_F.REDO.CARD.DES.HIS
    $INSERT I_F.REDO.CARD.REORDER.DEST


    GOSUB INIT
    GOSUB PROCESS
RETURN

*---------
INIT:
*---------
*Initialise the variables

*<<<<<<<<<<<<<<<<<<<<PACS00036010- Start --->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

*   CALL F.READ(FN.STOCK.ENTRY,Y.SE.SEL.LIST,R.STOCK.ENTRY,F.STOCK.ENTRY,Y.ERR.SE)

*  Y.BATCH.NO = R.STOCK.ENTRY<STO.ENT.LOCAL.REF,Y.BATCH.NO.POS>
* Y.CARD.TYPE = R.STOCK.ENTRY<STO.ENT.LOCAL.REF,Y.CARD.TYPE.POS,1>

*<<<<<<<<<<<<<<<<<<<<PACS00036010- Ends--->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    CALL F.READ(FN.REDO.CARD.REQUEST,Y.SE.SEL.LIST,R.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST,Y.ERR.CARD.REQ)
    Y.COMPANY = R.REDO.CARD.REQUEST<REDO.CARD.REQ.AGENCY>
    CALL F.READ(FN.REDO.CARD.REORDER.DEST,Y.COMPANY,R.REDO.CARD.REORDER.DEST,F.REDO.CARD.REORDER.DEST,Y.ERR.REORDER)

    CALL F.READ(FN.REDO.CARD.DES.HIS,Y.DES.ID,R.REDO.CARD.DES.HIS,F.REDO.CARD.DES.HIS,Y.DES.ERR)

RETURN
*---------
PROCESS:
*---------
*Calculates destruction date and write the REDO.CARD.DES.HIS table

    CARD.TYPE = R.REDO.CARD.REQUEST<REDO.CARD.REQ.CARD.TYPE>
    TYPE.CNTR = DCOUNT(CARD.TYPE,@VM)
    LOOP.CNTR =1
    LOOP
    WHILE LOOP.CNTR LE TYPE.CNTR
        GOSUB PROCESS.NEW
        LOOP.CNTR += 1
    REPEAT

RETURN
*---------
PROCESS.NEW:
*---------

    R.REDO.CARD.DES.HIS<REDO.DES.HIS.CARD.TYPE> = R.REDO.CARD.REQUEST<REDO.CARD.REQ.CARD.TYPE,LOOP.CNTR>
*        R.REDO.CARD.DES.HIS<REDO.DES.HIS.CARD.START.NO> = R.REDO.CARD.REQUEST<REDO.CARD.REQ.CARD.START.NO,LOOP.CNTR>

*<<<<<<<<<<<<<<<<<<<<PACS00036010- Start --->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

*        R.REDO.CARD.DES.HIS<REDO.DES.HIS.DATE.RECD.BRANCH> = R.STOCK.ENTRY<STO.ENT.IN.OUT.DATE>

*<<<<<<<<<<<<<<<<<<<<PACS00036010- Ends--->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    DATE.BR.RECIEVE = R.REDO.CARD.REQUEST<REDO.CARD.REQ.BR.RECEIVE.DATE>
    R.REDO.CARD.DES.HIS<REDO.DES.HIS.DATE.RECD.BRANCH> = DATE.BR.RECIEVE
    R.REDO.CARD.DES.HIS<REDO.DES.HIS.QTY.RECEIVED> =  R.REDO.CARD.REQUEST<REDO.CARD.REQ.REGOFF.ACCEPTQTY,LOOP.CNTR>
    R.REDO.CARD.DES.HIS<REDO.DES.HIS.AGENCY> = R.REDO.CARD.REQUEST<REDO.CARD.REQ.AGENCY>

*<<<<<<<<<<<<<<<<<<<<PACS00036010- Start --->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    Y.PERS.CARD =  R.REDO.CARD.REQUEST<REDO.CARD.REQ.PERS.CARD,LOOP.CNTR>
    IF Y.PERS.CARD EQ '' THEN
        Y.EMBOSS.TYPE = 'PREEMBOZADA'
    END ELSE
        Y.EMBOSS.TYPE = 'PERSONALIZADA'
    END

*<<<<<<<<<<<<<<<<<<<<PACS00036010- Ends--->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    Y.CARD.TYPE.LOOP = R.REDO.CARD.REQUEST<REDO.CARD.REQ.CARD.TYPE,LOOP.CNTR>
    Y.DES.CARD.TYPE = R.REDO.CARD.REORDER.DEST<REDO.REORD.DEST.CARD.TYPE>

*<<<<<<<<<<<<<<<<<<<<PACS00036010- Start --->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    LOCATE  Y.CARD.TYPE.LOOP IN Y.DES.CARD.TYPE<1,1> SETTING CARD.DES.POS THEN


*Y.CARD.SERIES.LOOP = R.REDO.CARD.REQUEST<REDO.CARD.REQ.CARD.SERIES.ID,LOOP.CNTR>
*Y.DES.CARD.SERIES = R.REDO.CARD.REORDER.DEST<REDO.REORD.DEST.CARD.SERIES>
*  LOCATE Y.CARD.SERIES.LOOP IN Y.DES.CARD.SERIES<1,1,1> SETTING CARD.DES.SERIES.POS THEN

        Y.DEST.NO.OF.DAYS = ''

        IF Y.PERS.CARD EQ '' THEN
            Y.DEST.NO.OF.DAYS = R.REDO.CARD.REORDER.DEST<REDO.REORD.DEST.PREEMB.DEST.DAYS><1,CARD.DES.POS>
        END ELSE
            Y.DEST.NO.OF.DAYS = R.REDO.CARD.REORDER.DEST<REDO.REORD.DEST.PERS.DEST.DAYS><1,CARD.DES.POS>
        END
*END
    END

*<<<<<<<<<<<<<<<<<<<<PACS00036010---Ends ---->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    IF Y.DEST.NO.OF.DAYS THEN
        Y.DEST.NO.OF.DAYS = Y.DEST.NO.OF.DAYS:"W"

        Y.DEST.WORKING.DAY =  R.DATES(EB.DAT.LAST.WORKING.DAY)
        CALL CDT('',Y.DEST.WORKING.DAY,Y.DEST.NO.OF.DAYS)
        R.REDO.CARD.DES.HIS<REDO.DES.HIS.DEST.DATE> = Y.DEST.WORKING.DAY

        Y.NO.OF.DAYS = 'C'
        CALL CDD('',DATE.BR.RECIEVE, Y.DEST.WORKING.DAY, Y.NO.OF.DAYS)

        R.REDO.CARD.DES.HIS<REDO.DES.HIS.PLASTIC.STATUS> = "Plastic cards with ":Y.NO.OF.DAYS:" days in branch"

*************AUDIT FIELDS**********
        Y.CURR.NO = R.REDO.CARD.DES.HIS<REDO.DES.HIS.CURR.NO>
        R.REDO.CARD.DES.HIS<REDO.DES.HIS.CURR.NO> = Y.CURR.NO + 1
        R.REDO.CARD.DES.HIS<REDO.DES.HIS.DEPT.CODE> = R.USER<EB.USE.DEPARTMENT.CODE>
        R.REDO.CARD.DES.HIS<REDO.DES.HIS.INPUTTER> = C$T24.SESSION.NO:'_':OPERATOR  ;*R22 AUTO CONVERSTION TNO TO C$T24.SESSION.NO
        R.REDO.CARD.DES.HIS<REDO.DES.HIS.AUTHORISER>=C$T24.SESSION.NO:'_':OPERATOR  ;*R22 AUTO CONVERSTION TNO TO C$T24.SESSION.NO

        TEMPTIME = OCONV(TIME(),"MTS")
        TEMPTIME = TEMPTIME[1,5]
        CHANGE ':' TO '' IN TEMPTIME
        CHECK.DATE = DATE()
        R.REDO.CARD.DES.HIS<REDO.DES.HIS.DATE.TIME>=OCONV(CHECK.DATE,"DY2"):FMT(OCONV(CHECK.DATE,"DM"),"R%2"):FMT(OCONV(CHECK.DATE,"DD"),"R%2"):TEMPTIME

        R.REDO.CARD.DES.HIS<REDO.DES.HIS.CO.CODE>   = Y.COMPANY
**************************************
        Y.DES.ID = Y.SE.SEL.LIST:'-':CARD.TYPE<1,LOOP.CNTR>
        CALL F.WRITE(FN.REDO.CARD.DES.HIS,Y.DES.ID,R.REDO.CARD.DES.HIS)
    END
RETURN
END
