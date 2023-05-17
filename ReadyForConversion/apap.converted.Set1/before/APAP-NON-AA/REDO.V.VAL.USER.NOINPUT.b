*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.VAL.USER.NOINPUT
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :SHANKAR RAJU
*Program   Name    :REDO.V.VAL.STATUS.NOINPUT
*Reference Number  :HD1048505
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is to make the USER field NOINPUT

*LINKED WITH       :
* ----------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.TELLER.ID

  IF COMI NE '' THEN
    T(TT.TID.USER)<3>='NOINPUT'
    IF R.NEW(TT.TID.STATUS) NE '' THEN
      T(TT.TID.STATUS)<3>='NOINPUT'
    END
  END

  RETURN
END
