SUBROUTINE REDO.B.MOVE.UNUSED.SELECT
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    :
*--------------------------------------------------------------------------------------------------------
*Description       : This is a Multi threaded Select Routine Which is used to select REDO.CARD.NO.LOCK table
*In Parameter      :
*Out Parameter     :
*Files  Used       : As             I/O          Mode
*
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
*  02/08/2010       REKHA S            ODR-2010-03-0400 B.166      Initial Creation
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.MOVE.UNUSED.COMMON

    GOSUB PROCESS

RETURN

********
PROCESS:
********

    SEL.CMD = 'SELECT ' : FN.REDO.CARD.NO.LOCK
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)

    CALL BATCH.BUILD.LIST('',SEL.LIST)
RETURN
END
