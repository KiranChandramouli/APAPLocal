*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.DEL.AVAILABILITY.LOAD
*-----------------------------------------------------------------------------
* Description:
* This routine is a multithreaded routine to delete the records in the mentioned applns
*------------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : MARIMUTHU S
* PROGRAM NAME : REDO.V.DEL.AVAILABILITY.LOAD
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE         DESCRIPTION
* 15.04.2010  MARIMUTHU S     ODR-2009-11-0200  INITIAL CREATION
* -----------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.H.DEPOSIT.RECEIPTS
$INSERT I_F.REDO.H.PASSBOOK.INVENTORY
$INSERT I_F.REDO.H.ADMIN.CHEQUES
$INSERT I_F.REDO.H.BANK.DRAFTS
$INSERT I_F.REDO.H.DEBIT.CARDS
$INSERT I_REDO.V.DEL.AVAILABILITY.COMMON
*-----------------------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------------------
  GOSUB INIT
  GOSUB OPENFILES
  GOSUB PROGRAM.END
*-----------------------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------------------
OPENFILES:
*-----------------------------------------------------------------------------------------
  FN.REDO.H.DEPOSIT.RECEIPTS = 'F.REDO.H.DEPOSIT.RECEIPTS'
  F.REDO.H.DEPOSIT.RECEIPTS = ''
  CALL OPF(FN.REDO.H.DEPOSIT.RECEIPTS,F.REDO.H.DEPOSIT.RECEIPTS)

  FN.REDO.H.PASSBOOK.INVENTORY = 'F.REDO.H.PASSBOOK.INVENTORY'
  F.REDO.H.PASSBOOK.INVENTORY = ''
  CALL OPF(FN.REDO.H.PASSBOOK.INVENTORY,F.REDO.H.PASSBOOK.INVENTORY)

  FN.REDO.H.ADMIN.CHEQUES = 'F.REDO.H.ADMIN.CHEQUES'
  F.REDO.H.ADMIN.CHEQUES = ''
  CALL OPF(FN.REDO.H.ADMIN.CHEQUES,F.REDO.H.ADMIN.CHEQUES)

  FN.REDO.H.BANK.DRAFTS = 'F.REDO.H.BANK.DRAFTS'
  F.REDO.H.BANK.DRAFTS = ''
  CALL OPF(FN.REDO.H.BANK.DRAFTS,F.REDO.H.BANK.DRAFTS)

  FN.REDO.H.DEBIT.CARDS = 'F.REDO.H.DEBIT.CARDS'
  F.REDO.H.DEBIT.CARDS = ''
  CALL OPF(FN.REDO.H.DEBIT.CARDS,F.REDO.H.DEBIT.CARDS)

  RETURN
*-----------------------------------------------------------------------------------------
PROGRAM.END:
*-----------------------------------------------------------------------------------------
END
