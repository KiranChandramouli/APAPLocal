*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.AUTO.PAYMENT.SELECT

*------------------------------------------------------------------
** COMPANY NAME : APAP
* DEVELOPED BY : JEEVA T
* PROGRAM NAME : REDO.B.DIRECT.DEBIT.SELECT
*------------------------------------------------------------------
* Description : This is the update rotuine which will select all the customer
******************************************************************
*31-10-2011         JEEVAT             EB.LOOKUP select has been removed
*------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.AUTO.PAYMENT.COMMON

  GOSUB ACCOUNT.SELECT
  RETURN
*-----------------------------------------------------
ACCOUNT.SELECT:
*-----------------------------------------------------

  SEL.CMD.SR = "SELECT ":FN.REDO.DIRECT.DEBIT.ACCOUNTS
  CALL EB.READLIST(SEL.CMD.SR,SEL.LIST.SR,'',NO.REC,PGM.ERR)
  CALL BATCH.BUILD.LIST('',SEL.LIST.SR)

  RETURN
END
