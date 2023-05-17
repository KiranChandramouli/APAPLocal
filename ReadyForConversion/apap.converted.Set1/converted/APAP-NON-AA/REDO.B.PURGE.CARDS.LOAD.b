SUBROUTINE REDO.B.PURGE.CARDS.LOAD
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.B.PURGE.CARDS.LOAD
*--------------------------------------------------------------------------------------------------------
*Description       :             This load routine initialises and opens necessary files
*                    and gets the position of the local reference fields
*In Parameter      :
*Out Parameter     :
*Files  Used       :
*
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
*  30/07/2010       REKHA S            ODR-2010-03-0400 B166      Initial Creation
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.PURGE.CARDS.COMMON
    $INSERT I_F.LATAM.CARD.ORDER

    GOSUB INIT
RETURN

*****
INIT:
*****
    FN.LATAM.CARD.ORDER = 'F.LATAM.CARD.ORDER'
    F.LATAM.CARD.ORDER= ''
    CALL OPF(FN.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER)

    FN.CARD.TYPE = 'F.CARD.TYPE'
    F.CARD.TYPE = ''
    CALL OPF(FN.CARD.TYPE,F.CARD.TYPE)

    APPL.ARRAY = 'CARD.TYPE'
    FLD.ARRAY  = 'L.CT.PURGE.FQU'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.CT.PURGE.FQU = FLD.POS<1,1>

RETURN
