*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE MULTI.TRANSACTION.SERVICE.ID
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
  GOSUB OPENFILES
  GOSUB PROCESS
  GOSUB GOEND
  RETURN
*---------
INIT:
  RETURN

*--------------
OPENFILES:

  FN.MULTI.TRANSACTION.SERVICE = 'F.MULTI.TRANSACTION.SERVICE'
  F.MULTI.TRANSACTION.SERVICE = ''
  CALL OPF(FN.MULTI.TRANSACTION.SERVICE,F.MULTI.TRANSACTION.SERVICE)

  FN.TELLER.USER = 'F.TELLER.USER'
  F.TELLER.USER = ''
  CALL OPF(FN.TELLER.USER,F.TELLER.USER)

  FN.TELLER.ID = 'F.TELLER.ID'
  F.TELLER.ID = ''
  CALL OPF(FN.TELLER.ID,F.TELLER.ID)
  RETURN

*---------
PROCESS:

  Y.USER = OPERATOR

  CALL F.READ(FN.TELLER.USER,Y.USER,R.TELLER.USER,F.TELLER.USER,F.ERR)
  IF R.TELLER.USER EQ '' THEN
    E = 'TT-TID.TILL.NOT.EXIST.CURRENT.USER'
  END ELSE
    CALL F.READ(FN.TELLER.ID,R.TELLER.USER<1>,R.TELLER.ID,F.TELLER.ID,TELLER.ID.ERR)
    IF R.TELLER.ID<TT.TID.STATUS> NE 'OPEN' THEN
      E = 'TT-TILL.NOT.OPEN'
    END
  END
  RETURN
*------------
GOEND:
END
