*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.DEAL.SLIP.QUEUE.PURGE.SELECT
*-----------------------------------------------------------------------------
* Description:
* This routine is a multithreaded routine to select the records in the mentioned applns
*------------------------------------------------------------------------------------------
* LINKED WITH
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Sakthi Sellappillai
* PROGRAM NAME : REDO.B.DEAL.SLIP.QUEUE.PURGE.SELECT
* ODR          :
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                     REFERENCE               DESCRIPTION
*===========      =================        =================       ================
*13.12.2010       SRIRAMAN.C               CR020                   INITIAL CREATION
*------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_BATCH.FILES
$INSERT I_F.REDO.APAP.H.DEAL.SLIP.QUEUE
$INSERT I_F.REDO.APAP.H.DEAL.SLIP.QUEUE.PARAM
$INSERT I_REDO.B.DEAL.SLIP.QUEUE.PURGE.COMMON


  GOSUB PROCESS

  RETURN
*------------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------------

  SEL.INPUT.CMD=" SELECT ":FN.REDO.APAP.H.DEAL.SLIP.QUEUE
  CALL EB.READLIST(SEL.INPUT.CMD,SEL.LIST,'',NO.OF.RECS,REC.ERR)

  Y.PURGE.ID = SEL.LIST

  CALL BATCH.BUILD.LIST('',Y.PURGE.ID)

  RETURN
************************************
END
*-------------------------------------*END OF SUBROUTINE*----------------------------------
