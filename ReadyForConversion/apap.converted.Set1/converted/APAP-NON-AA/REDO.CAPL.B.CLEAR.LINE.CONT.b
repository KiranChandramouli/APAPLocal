SUBROUTINE REDO.CAPL.B.CLEAR.LINE.CONT(REDO.CAPL.L.RE.STAT.LINE.CONT.ID)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CAPL.B.CLEAR.LINE.CONT
*--------------------------------------------------------------------------------------------------------
*Description       : This is a BATCH routine, this batch routine clears the backup taken from
*                    the file RE.STAT.LINE.CONT inorder to extract the back dated reports from the system
*Linked With       : Batch BNK/RE.BUILD.SLC
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : REDO.CAPL.L.RE.STAT.LINE.CONT    As              I-O              Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                    Reference                 Description
*   ------             -----                 -------------              -------------
* 26 Oct 2010       Shiva Prasad Y       ODR-2009-12-0294 C.12         Initial Creation
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CAPL.L.RE.STAT.LINE.CONT
    $INSERT I_REDO.CAPL.B.CLEAR.LINE.CONT.COMMON
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts

    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

    CALL F.DELETE(FN.REDO.CAPL.L.RE.STAT.LINE.CONT,REDO.CAPL.L.RE.STAT.LINE.CONT.ID)

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* ENd of Program
