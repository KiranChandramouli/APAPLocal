SUBROUTINE REDO.B.PURGE.CARDS.SELECT
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.B.PURGE.CARDS.SELECT
*--------------------------------------------------------------------------------------------------------
*Description       :  This is a Multi threaded Select Routine Which is used to select LATAM.CARD.ORDER table
*                     with CARD.STATUS equal to '93'
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
    $INSERT I_F.LATAM.CARD.ORDER
    $INSERT I_REDO.B.PURGE.CARDS.COMMON

    GOSUB PROCESS
RETURN

********
PROCESS:
********
    SEL.CMD = 'SELECT ':FN.LATAM.CARD.ORDER:' WITH CARD.STATUS EQ 93'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,Y.RET.CODE)

    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN
END
