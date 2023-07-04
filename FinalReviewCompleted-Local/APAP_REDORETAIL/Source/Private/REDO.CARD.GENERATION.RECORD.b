* @ValidationCode : MjoyMTM4NDkyNDcwOkNwMTI1MjoxNjgxODI4MDA0NDAyOklUU1M6LTE6LTE6MjQzOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 Apr 2023 19:56:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 243
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.CARD.GENERATION.RECORD
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.GENERATION.RECORD
*------------------------------------------------------------------------------

*Description  : This routine is template level record routine for REDO.CARD.GENERATION
*Linked With  : version REDO.CARD.DES.HIS,DESTRUCT
*In Parameter : N/A
*Out Parameter: N/A
*Linked File  : REDO.CARD.REQUEST In Read mode
*               CARD.TYPE In Read mode

*-------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                              Reference               Description
*   ------         ------                           -------------            -------------
* 28-07-2010    Jeyachandran S/Mohammed Anies K    ODR-2010-03-0400         Initial Creation
* 11-04-2023    CONVERSION TOOL                  AUTO R22 CODE CONVERSION       VM TO @VM ,FM TO @FM
* 11-04-2023    jayasurya H                      MANUAL R22 CODE CONVERSION     NO CHANGES
*--------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CARD.TYPE
    $INSERT I_F.REDO.CARD.REQUEST
    $INSERT I_F.REDO.CARD.GENERATION
*--------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA
RETURN

*--------------------------------------------------------------------------------

**********
OPEN.PARA:
**********
* In this para of code file variables are initialised and opened

    FN.REDO.CARD.REQUEST= 'F.REDO.CARD.REQUEST'
    F.REDO.CARD.REQUEST = ''
    CALL OPF(FN.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST)

    FN.CARD.TYPE = 'F.CARD.TYPE'
    F.CARD.TYPE = ''
    R.CARD.TYPE = ''

RETURN
*------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************

*Main Processing Section
    IF V$FUNCTION NE 'I' THEN
        RETURN
    END
    Y.REDO.CARD.REQUEST.ID = ID.NEW

    GOSUB READ.REDO.CARD.REQUEST

    IF R.REDO.CARD.REQUEST THEN
        GOSUB GET.LOCAL.REF.FIELDS
        R.NEW(REDO.CARD.GEN.AGENCY) = R.REDO.CARD.REQUEST<REDO.CARD.REQ.AGENCY>
        Y.TOT.CARD.TYPES = DCOUNT(R.REDO.CARD.REQUEST<REDO.CARD.REQ.CARD.TYPE>,@VM)
        Y.INIT.CARD.COUNT = 1
        LOOP
        WHILE Y.INIT.CARD.COUNT LE Y.TOT.CARD.TYPES

            R.NEW(REDO.CARD.GEN.CARD.TYPE)<1,Y.INIT.CARD.COUNT> = R.REDO.CARD.REQUEST<REDO.CARD.REQ.CARD.TYPE,Y.INIT.CARD.COUNT>
            R.NEW(REDO.CARD.GEN.BIN)<1,Y.INIT.CARD.COUNT> = R.REDO.CARD.REQUEST<REDO.CARD.REQ.BIN,Y.INIT.CARD.COUNT>
            R.NEW(REDO.CARD.GEN.PERSONLISED)<1,Y.INIT.CARD.COUNT> = R.REDO.CARD.REQUEST<REDO.CARD.REQ.PERS.CARD,Y.INIT.CARD.COUNT>
            R.NEW(REDO.CARD.GEN.CARD.SERIES)<1,Y.INIT.CARD.COUNT> = R.REDO.CARD.REQUEST<REDO.CARD.REQ.CARD.SERIES.ID,Y.INIT.CARD.COUNT>
            R.NEW(REDO.CARD.GEN.CARD.START.NO)<1,Y.INIT.CARD.COUNT> = R.REDO.CARD.REQUEST<REDO.CARD.REQ.CARD.START.NO,Y.INIT.CARD.COUNT>
            R.NEW(REDO.CARD.GEN.QTY)<1,Y.INIT.CARD.COUNT> = R.REDO.CARD.REQUEST<REDO.CARD.REQ.REGOFF.ACCEPTQTY,Y.INIT.CARD.COUNT>
            GOSUB GET.FREQUENCY
            R.NEW(REDO.CARD.GEN.EXPIRY)<1,Y.INIT.CARD.COUNT> = Y.EXPIRY.DATE
            Y.INIT.CARD.COUNT +=1
        REPEAT

    END
*------------------------------------------------------------------------------
**********************
READ.REDO.CARD.REQUEST:
**********************
    R.REDO.CARD.REQUEST = ''
    REDO.CARD.REQUEST.ERR = ''
    CALL F.READ(FN.REDO.CARD.REQUEST,Y.REDO.CARD.REQUEST.ID,R.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST,REDO.CARD.REQUEST.ERR)

RETURN
*------------------------------------------------------------------------------
********************
GET.LOCAL.REF.FIELDS:
********************
*In this para of code local reference field positions are identified

    APPL.ARRAY='CARD.TYPE'
    FLD.ARRAY='L.CT.RENEW.PROC'
    FLD.POS=''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.CT.RENEW.PROC.POS = FLD.POS<1,1>

RETURN
*------------------------------------------------------------------------------
*************
GET.FREQUENCY:
*************

    Y.CARD.TYPE.ID = R.REDO.CARD.REQUEST<REDO.CARD.REQ.CARD.TYPE,Y.INIT.CARD.COUNT>
    GOSUB READ.CARD.TYPE
    Y.EXPIRY.DATE = ''
    IF R.CARD.TYPE THEN
        Y.EXPIRY.DATE = R.CARD.TYPE<CARD.TYPE.LOCAL.REF,LOC.L.CT.RENEW.PROC.POS>
        Y.CURRENT.DATE = TODAY
        IF Y.CURRENT.DATE AND Y.EXPIRY.DATE THEN
            CALL CALENDAR.DAY(Y.CURRENT.DATE,"+",Y.EXPIRY.DATE)

            Y.EXPIRY.DATE.BCK=Y.EXPIRY.DATE
            Y.EXPIRY.DATE.BCK[7,2]='32'
            CALL CDT('',Y.EXPIRY.DATE.BCK,'-01C')
            Y.EXPIRY.DATE=Y.EXPIRY.DATE.BCK
        END
    END

RETURN
*------------------------------------------------------------------------------
***************
READ.CARD.TYPE:
***************
    R.CARD.TYPE = ''
    CARD.TYPE.ERR = ''
    CALL F.READ(FN.CARD.TYPE,Y.CARD.TYPE.ID,R.CARD.TYPE,F.CARD.TYPE,CARD.TYPE.ERR)

RETURN
*------------------------------------------------------------------------------
END
