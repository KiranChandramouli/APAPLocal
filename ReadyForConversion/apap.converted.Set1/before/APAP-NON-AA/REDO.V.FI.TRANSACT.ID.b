*-----------------------------------------------------------------------------
* <Rating>-43</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE  REDO.V.FI.TRANSACT.ID

*------------------------------------------------------------------------------------------------------------------
*  Company Name      : APAP Bank
*  Developed By      : Temenos Application Management
*  Program Name      : REDO.V.VAL.PARAM.ENCRIPT
*  Date              : 24.11.2010
*------------------------------------------------------------------------------------------------------------------
*Description:
*------------------------------------------------------------------------------------------------------------------
* Input/Output:
* -------------
* In  : --N/A--
* Out : --N/A--
*------------------------------------------------------------------------------------------------------------------
* Dependencies:
* -------------
* Calls     : --N/A--
* Called By : --N/A--
*------------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Date              Name              Reference                    Version
* -------           ----              ----------                   --------
* 24.11.2010       Joaquin Costa      ODR-2010-03-0025             Initial Version
*------------------------------------------------------------------------------------------------------------------
*
$INSERT I_COMMON
$INSERT I_EQUATE
*
$INSERT I_F.REDO.FI.LB.BPROC
*
*************************************************************************
*
  GOSUB INITIALISE
  GOSUB OPEN.FILES
  GOSUB CHECK.PRELIM.CONDITIONS
  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END
*
  RETURN
*
* ======
PROCESS:
* ======
*
  BEGIN CASE
  CASE TRANSACTION.TYPE EQ 'TT'
    CALL F.READ(FN.TELLER,COMI,R.TELLER,F.TELLER,YER.TT)
    IF NOT(R.TELLER) THEN
      ETEXT = "EB-Record.&.missing.in.table.&":FM:COMI:VM:FN.TELLER
      AF = REDO.FI.LB.BPROC.TRANSACTION.ID
      CALL STORE.END.ERROR
    END

  CASE TRANSACTION.TYPE EQ 'FT'
    CALL F.READ(FN.FUNDS.TRANSFER,COMI,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,YER.FT)
    IF NOT(R.FUNDS.TRANSFER) THEN
      ETEXT = "EB-Record.&.missing.in.table.&":FM:COMI:VM:FN.FUNDS.TRANSFER
      AF = REDO.FI.LB.BPROC.TRANSACTION.ID
      CALL STORE.END.ERROR

    END

  CASE 1
    ETEXT = "EB-Invalid.Transaction.Type":FM:COMI
*        CALL STORE.END.ERROR

  END CASE
*
  RETURN
*
* =========
INITIALISE:
* =========
*
  PROCESS.GOAHEAD           = 0
  LOOP.CNT                  = 1
  MAX.LOOPS                 = 1
*
  IF MESSAGE NE 'VAL' THEN
    PROCESS.GOAHEAD = 1
  END

*
*   TELLER TRANSACTION TABLE
*
  FN.TELLER   = 'F.TELLER'
  F.TELLER    = ''
  R.TELLER    = ''
*
*   FUNDS.TRANSFER TABLE
*
  FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
  F.FUNDS.TRANSFER  = ''
  R.FUNDS.TRANSFER  = ''
*
*
*
  TRANSACTION.TYPE = COMI[1,2]
*
  RETURN
*
* =========
OPEN.FILES:
* =========
*
*
  RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
  LOOP
  WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
    BEGIN CASE

    CASE LOOP.CNT EQ 1
      IF TRANSACTION.TYPE EQ ''  THEN
        PROCESS.GOAHEAD = 0
        AF = REDO.FI.LB.BPROC.TRANSACTION.ID
        ETEXT = "EB-Invalid.Transaction.Type":FM:COMI
        CALL STORE.END.ERROR

      END

    END CASE

    LOOP.CNT +=1
  REPEAT
*
  RETURN
*
END


