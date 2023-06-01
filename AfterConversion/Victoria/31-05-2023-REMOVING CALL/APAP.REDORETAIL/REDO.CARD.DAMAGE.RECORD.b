* @ValidationCode : MjotOTEyMDMyNDQwOkNwMTI1MjoxNjgxODI4MDAzMTc2OklUU1M6LTE6LTE6NDQzOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 Apr 2023 19:56:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 443
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.CARD.DAMAGE.RECORD
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.DAMAGE.RECORD
*--------------------------------------------------------------------------------------------------------
*Description  : This is a RECORD routine to default the STOCK.ENTRY.ID field
*Linked With  : Application REDO.CARD.DAMAGE
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 4 March 2011     Swaminathan     ODR-2010-03-0400         Initial Creation
* 16 Jun  2011     Kavitha         ODR-2010-03-0400         PACS00064220 fix
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*11-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM
*11-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CARD.DAMAGE
    $INSERT I_F.REDO.CARD.REQUEST
    $INSERT I_F.REDO.STOCK.ENTRY
    $INSERT I_F.REDO.STOCK.REGISTER
    $INSERT I_REDO.CARD.DAMAGE.COMMON

*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA
RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of code file variables are initialised and opened

    FN.CARD.REQUEST = 'F.REDO.CARD.REQUEST'
    F.CARD.REQUEST = ''
    CALL OPF(FN.CARD.REQUEST,F.CARD.REQUEST)

*PACS00024249 -S

    FN.STOCK.ENTRY = 'F.REDO.STOCK.ENTRY'
    F.STOCK.ENTRY  = ''
    CALL OPF(FN.STOCK.ENTRY,F.STOCK.ENTRY)

*Local field card type from STOCK.ENTRY
*    Y.LRF.APPL = "STOCK.ENTRY"
*   Y.LRF.FIELDS = 'L.SE.BATCH.NO'
*   FIELD.POS = ''
*   CALL MULTI.GET.LOC.REF(Y.LRF.APPL,Y.LRF.FIELDS,FIELD.POS)
*   Y.CARD.TYPE.POS = FIELD.POS<1,1>

*PACS00024249 -E

    FN.REDO.CARD.NUMBERS = 'F.REDO.CARD.NUMBERS'
    F.REDO.CARD.NUMBERS = ''
    CALL OPF(FN.REDO.CARD.NUMBERS,F.REDO.CARD.NUMBERS)

RETURN
*----------------------------------------------------------------------------------------------------------
************
PROCESS.PARA:
**************
    Y.REQUEST.ID = ID.NEW
    CALL F.READ(FN.CARD.REQUEST,Y.REQUEST.ID,R.CARD.REQUEST,F.CARD.REQUEST,Y.ERR.REQ)
    Y.SE.ID = R.CARD.REQUEST<REDO.CARD.REQ.BRANCH.SE.ID>
    IF Y.SE.ID NE '' THEN
        R.NEW(REDO.CARD.DAM.STOCK.ENTRY.ID) = Y.SE.ID
    END
    R.NEW(REDO.CARD.DAM.AGENCY) = R.CARD.REQUEST<REDO.CARD.REQ.AGENCY>
    GOSUB READ.STOCK.ENTRY

    GOSUB DEFAULT.VALUES


RETURN
*-------------------
READ.STOCK.ENTRY:

*STOCK.ENTRY record is read for the given stock entry id
    R.STOCK.ENTRY   =''
    STOCK.ENTRY.ERR = ''
    Y.STOCK.ENTRY.ID = Y.SE.ID
    CALL F.READ(FN.STOCK.ENTRY,Y.STOCK.ENTRY.ID,R.STOCK.ENTRY,F.STOCK.ENTRY,STOCK.ENTRY.ERR)

*PACS00024249 -S
*    BATCH.NO = R.STOCK.ENTRY<STO.ENT.LOCAL.REF,Y.CARD.TYPE.POS>
* BATCH.NO = R.STOCK.ENTRY<STK.BATCH.NO>

*  CALL F.READ(FN.CARD.REQUEST,BATCH.NO,R.CARD.REQUEST,F.CARD.REQUEST,REQ.ERR)

RETURN
*--------------------
DEFAULT.VALUES:

*Defaulting values into the fields
* Y.TOT.STOCK.SERIES.IDS = DCOUNT(R.STOCK.ENTRY<STK.STOCK.SERIES>,VM)
    STOCK.ENT.SER = R.STOCK.ENTRY<STK.STOCK.SERIES>

    REQ.SERIES = R.CARD.REQUEST<REDO.CARD.REQ.CARD.SERIES.ID>

    Y.TOT.STOCK.SERIES.IDS = DCOUNT(REQ.SERIES,@VM)

    CHANGE @VM TO @FM IN STOCK.ENT.SER
    CHANGE @VM TO @FM IN REQ.SERIES


    Y.INIT.SS.ID = 1
    LOOP
    WHILE Y.INIT.SS.ID LE Y.TOT.STOCK.SERIES.IDS

*        LOCATE STOCK.ENT.SER<Y.INIT.SS.ID> IN REQ.SERIES SETTING SER.POS THEN
        CARD.REQ.TYPE = R.CARD.REQUEST<REDO.CARD.REQ.CARD.TYPE,Y.INIT.SS.ID>
        R.NEW(REDO.CARD.DAM.CARD.TYPE)<1,Y.INIT.SS.ID> = CARD.REQ.TYPE

*----------PACS00054728, PACS00064220---------------------------------------------------------
        IF V$FUNCTION EQ "I" AND CARD.REQ.TYPE EQ REDO.CARD.TYPE THEN
            R.NEW(REDO.CARD.DAM.CARD.NUMBER)<1,Y.INIT.SS.ID,1>= REDO.CARD.NO
        END ELSE

*            R.NEW(REDO.CARD.DAM.CARD.NUMBER)<1,Y.INIT.SS.ID> = ''
        END
*----------PACS00054728, PACS00064220---------------------------------------------------------

*        END

        R.NEW(REDO.CARD.DAM.CARD.SERIES)<1,Y.INIT.SS.ID>      = REQ.SERIES<Y.INIT.SS.ID>

*        R.NEW(REDO.CARD.DAM.CARD.START.NO)<1,Y.INIT.SS.ID>    = R.STOCK.ENTRY<STO.ENT.STOCK.START.NO,Y.INIT.SS.ID>

        R.NEW(REDO.CARD.DAM.DATE.REC.BRANCH)<1,Y.INIT.SS.ID> =  R.CARD.REQUEST<REDO.CARD.REQ.BR.RECEIVE.DATE>
        R.NEW(REDO.CARD.DAM.QTY.RECEIVED)<1,Y.INIT.SS.ID>     = R.CARD.REQUEST<REDO.CARD.REQ.REGOFF.ACCEPTQTY,Y.INIT.SS.ID>

        Y.INIT.SS.ID +=1
    REPEAT

RETURN
*--------------
*PACS00024249 -E

END
