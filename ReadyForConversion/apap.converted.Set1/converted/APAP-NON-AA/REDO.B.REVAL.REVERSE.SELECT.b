SUBROUTINE REDO.B.REVAL.REVERSE.SELECT
*---------------------------------------------------------------------------------------------
*DESCRIPTION
*------------
*
*.SELECT routine which selects CATEG.ENTRY id's and SPEC.ENTRY id's.
*
*---------------------------------------------------------------------------------------------
* Input / Output
* --------------
* IN     :
* OUT    :
*
* Dependencies
* ------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* CHANGE REQUEST / DEVELOPMENT REF:
*---------------------------------------------------------------------------------------------
* Revision History
* ----------------
* Date          Who                Reference                 Description
* 01-12-2011   Victor Panchi                         Multibooking
* 01-12-2011   Marcelo Gud                           Multibooking
*---------------------------------------------------------------------------------------------
* 30/08/2016 - Mod1 - Eashwar ITSS
*            - Changes made to select the details from RE.SPEC.ENT.LWORK.DAY instead of RE.CONSOL.SPEC.ENTRY
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_F.COMPANY
    $INSERT I_F.RE.CONSOL.SPEC.ENTRY
    $INSERT I_F.REDO.H.REVALUATION.PARAM
    $INSERT I_REDO.B.REVAL.REVERSE.COMMON
    $INSERT I_F.REDO.L.REVAL.FCY.PROD.POS
    $INSERT I_BATCH.FILES

    IF NOT(CONTROL.LIST) THEN
        CONTROL.LIST<-1> = 'PROCESS'
        CONTROL.LIST<-1> = 'MERGE'
    END


    GOSUB INITIALISE
    BEGIN CASE
        CASE CONTROL.LIST<1,1> EQ 'PROCESS'
            GOSUB PROCESS
        CASE CONTROL.LIST<1,1> EQ 'MERGE'
            GOSUB MERGE.SEL
        CASE 1

    END CASE

RETURN
*--------------------------------------------------------------------------------------
INITIALISE:
*--------------------------------------------------------------------------------------
*Initialising the variables needed for select routine

    SELECT.CMD = ''
    SELECT.LIST = ''
    NO.OF.RECORDS = ''
    SPEC.ERROR = ''

RETURN
*--------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------

*Doing a select on those categ entries whose PL.CATEGORY is equal
*to REV.PL.CATEG of REDO.H.REVALUATION.PARAM table.

* Mod1 S
*  SELECT.CMD = 'SELECT ' : FN.SPEC.ENTRY : ' WITH TRANSACTION.CODE EQ "RVL"'
*  SELECT.CMD := " AND BOOKING.DATE EQ ":TODAY
*  CALL EB.READLIST(SELECT.CMD,SELECT.LIST,'',NO.OF.RECORDS,SPEC.ERROR)
*  CALL BATCH.BUILD.LIST('',SELECT.LIST)
*  CRT  "SELECT.LIST " : SELECT.LIST
    LIST.PARAM = ''
    LIST.PARAM<2> = FN.RE.SPEC.ENT.LWORK.DAY
    CALL BATCH.BUILD.LIST(LIST.PARAM,'')
* Mod1 E

RETURN
*-------------------------------------------------------------------------
MERGE.SEL:

    CALL BATCH.BUILD.LIST('','MERGE.RECORDS')

RETURN
*----------------------FinalEnd-------------------------------------------
END
