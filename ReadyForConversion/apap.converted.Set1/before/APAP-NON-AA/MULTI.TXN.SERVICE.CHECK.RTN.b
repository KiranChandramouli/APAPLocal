*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE MULTI.TXN.SERVICE.CHECK.RTN
*----------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: JEYACHANDRAN S
* PROGRAM NAME:
* ODR NO      :
*----------------------------------------------------------------------
* DESCRIPTION  :This routine is used to retrive the informations from multiple files
* IN PARAMETER :NA
* OUT PARAMETER:NA
* LINKED WITH  :
* LINKED FILE  :
*----------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                 REFERENCE           DESCRIPTION
* 28.09.2010   Jeyachandran S                           INITIAL CREATION
*-------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.MULTI.TRANSACTION.SERVICE
$INSERT I_F.TELLER.ID

  GOSUB INIT
  GOSUB OPEN.FILES
  GOSUB PROCESS
  RETURN

*--------------------------------------------------------------------------------------
INIT:
*--------------------------------------------------------------------------------------

  FN.TELLER.USER = 'F.TELLER.USER'
  F.TELLER.USER = ''

  FN.TELLER.ID = 'F.TELLER.ID'
  F.TELLER.ID = '' ; REDO.MTS.TELLER.ID1 = ''
  RETURN
*--------------------------------------------------------------------------------------
OPEN.FILES:
*--------------------------------------------------------------------------------------

  CALL OPF(FN.TELLER.USER,F.TELLER.USER)
  CALL OPF(FN.TELLER.ID,F.TELLER.ID)

  RETURN
*--------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------

  CALL F.READ(FN.TELLER.USER,OPERATOR,R.TELLER.USER,F.TELLER.USER,TE.ERR)

  IF R.TELLER.USER EQ '' THEN
    E = 'TT-TID.TILL.NOT.EXIST.CURRENT.USER'
  END ELSE
    CALL F.READ(FN.TELLER.ID,R.TELLER.USER<1>,R.TELLER.ID,F.TELLER.ID,TELLER.ID.ERR)
    IF R.TELLER.ID<TT.TID.STATUS> NE 'OPEN' THEN
      E = 'TT-TILL.NOT.OPEN'
    END ELSE
      R.NEW(REDO.MTS.TELLER.ID) = R.TELLER.USER<1>
    END
  END
  RETURN
*--------------------------------------------------------------------------------------
END
