*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.TRANS.PROCESS.SELECT
*-----------------------------------------------------------------------------
* Description:
* This routine is a multithreaded routine to select the records in the mentioned application
*------------------------------------------------------------------------------------------
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* PROGRAM NAME : REDO.B.TRANS.PROCESS.SELECT
* ODR          : ODR-2010-08-0031
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                     REFERENCE               DESCRIPTION
*===========      =================        =================       ================
*07.10.2010       Sakthi Sellappillai      ODR-2010-09-0171        INITIAL CREATION
*------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_BATCH.FILES
$INSERT I_REDO.B.TRANS.PROCESS.COMMON
$INSERT I_F.REDO.SUPPLIER.PAYMENT
$INSERT I_F.REDO.FILE.DATE.PROCESS
$INSERT I_F.REDO.SUPPLIER.PAY.DATE
  GOSUB PROCESS
  RETURN
*------------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------------
  Y.THIRD.DAY.VAL = TODAY
  SEL.CMD   = "SELECT " :FN.REDO.FILE.DATE.PROCESS: " WITH @ID LIKE " :" ...":Y.THIRD.DAY.VAL:" AND (OFS.PROCESS EQ 'SUCCESS' OR OFS.PROCESS EQ 'FAILURE')"
  CALL EB.READLIST(SEL.CMD,BUILD.LIST,'',Y.SEL.CNT,Y.ERR)
  CALL BATCH.BUILD.LIST('',BUILD.LIST)
END
*-------------------------------------*END OF SUBROUTINE*----------------------------------
