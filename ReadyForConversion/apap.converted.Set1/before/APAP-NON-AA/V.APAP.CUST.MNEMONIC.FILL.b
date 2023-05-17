*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
*Description:
* This routine is attached to the Customer versions for create a new customer record and return appropriate error msgs
*================================================================================================================
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : V.APAP.CUST.MNEMONIC.FILL
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 11.06.2010      SUDHARSANAN S     ODR-2010-03-0128  INITIAL CREATION
* ----------------------------------------------------------------------------------------------------
*===================================================================================================================

  SUBROUTINE V.APAP.CUST.MNEMONIC.FILL

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CUSTOMER

  GOSUB INITIALISE
  GOSUB PROCESS

  RETURN

INITIALISE:

  CUST.MNEMONIC = ""
  RETURN

PROCESS:
  CUST.MNEMONIC = R.NEW(EB.CUS.MNEMONIC)
  IF (LEN(ID.NEW) GE 1) AND (LEN(ID.NEW) LE 9) THEN
    IF CUST.MNEMONIC EQ '' AND ID.NEW NE '' THEN
      R.NEW(EB.CUS.MNEMONIC) = 'A':ID.NEW
    END
  END ELSE
    E = "EB-CUST.MNEMONIC":FM:ID.NEW
  END
  RETURN
END
