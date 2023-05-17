*-----------------------------------------------------------------------------
* <Rating>-14</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.CUSTOMER.GENDER(Y.OUT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :SUDHARSANAN S
*Program   Name    :REDO.S.CUSTOMER.GENDER
*---------------------------------------------------------------------------------
*DESCRIPTION       : This program is used to get the gender values
* ----------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.USER
$INSERT I_REDO.DEAL.SLIP.COMMON
  GOSUB PROCESS
  RETURN
*********
PROCESS:
*********
* Y.OUT = VAR.GENDER
  VIRTUAL.TAB.ID='GENDER'     ;*EB.LOOKUP ID
  CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID)
  CNT.VALUES = DCOUNT( VIRTUAL.TAB.ID,FM)
  Y.LOOKUP.LIST=VIRTUAL.TAB.ID<2>       ;* EB.LOOKUP VALUES
  Y.LOOKUP.DESC=VIRTUAL.TAB.ID<CNT.VALUES>        ;* EB.LOOKUP DESCRIPTION
  CHANGE '_' TO FM IN Y.LOOKUP.LIST
  CHANGE '_' TO FM IN Y.LOOKUP.DESC
  LOCATE VAR.GENDER IN Y.LOOKUP.LIST SETTING POS1 THEN
    VAR.USER.LANG = R.USER<EB.USE.LANGUAGE>       ;* Get the values based on user language
    Y.OUT = Y.LOOKUP.DESC<POS1,VAR.USER.LANG>
    IF NOT(Y.OUT) THEN
      Y.OUT=Y.LOOKUP.DESC<POS1,1>
    END
  END ELSE
    Y.OUT = ''
  END

  RETURN
END
