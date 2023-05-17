*-----------------------------------------------------------------------------
* <Rating>30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.USER.RELATION.VALIDATE

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.USER.RELATION.VALIDATE
*--------------------------------------------------------------------------------
* Description:
*--------------------------------------------------------------------------------
*       This template routine is used to check the following cases,
*         1) Should not allow to create new record where the related user (USER.RELACIONADO) is same as ID
*         2) Should not allow to create relations between users with different type (code) of relation
*---------------------------------------------------------------------------------
* Modification History:
*---------------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 07-12-2010      SUJITHA.S   ODR-2009-06-0219   INITIAL CREATION
* 27/04/2011      GANESH H    PACS00023889       MODIFICATION
* --------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.USER.RELATION


  GOSUB INIT
  GOSUB USER.PROCESS

  RETURN

*------------------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------------------

  FN.REDO.USER.RELATION = 'F.REDO.USER.RELATION'
  F.REDO.USER.RELATION = ''
  R.REDO.USER.RELATION = ''
  CALL OPF(FN.REDO.USER.RELATION,F.REDO.USER.RELATION)

  Y.CURRENT.ID = ID.NEW
  Y.RELATED.USER = R.NEW(REDO.USR.REDO.RELATED.USER)

  RETURN

*--------------------------------------------------------------------------------------
USER.PROCESS:
*--------------------------------------------------------------------------------------


  Y.REL.COUNT = DCOUNT(Y.RELATED.USER,VM)
  Y.REL.INIT = 1
  LOOP
  WHILE Y.REL.INIT LE Y.REL.COUNT


    IF Y.CURRENT.ID EQ Y.RELATED.USER<1,Y.REL.INIT> THEN
      AF = REDO.USR.REDO.RELATED.USER
      AV = Y.REL.INIT
      ETEXT = 'EB-REL.USER1'
      CALL STORE.END.ERROR
    END
!PACS00023889-S
    AF=REDO.USR.REDO.RELATED.USER
    CALL DUP
!PACS00023889-E


    CALL F.READ(FN.REDO.USER.RELATION,Y.RELATED.USER<1,Y.REL.INIT>,R.REDO.USER.RELATION,F.REDO.USER.RELATION,REL.ERR)

    IF R.REDO.USER.RELATION THEN
      Y.EXIST.USER = R.REDO.USER.RELATION<REDO.USR.REDO.RELATED.USER>
      Y.EXIST.COUNT = DCOUNT(Y.EXIST.USER,VM)
      Y.EXIST.INIT = 1
      LOOP
      WHILE Y.EXIST.INIT LE Y.EXIST.COUNT
        Y.EXIST.ID = R.REDO.USER.RELATION<REDO.USR.REDO.RELATED.USER,Y.EXIST.INIT>

        IF Y.EXIST.ID EQ Y.CURRENT.ID THEN
          AF = REDO.USR.REDO.RELATED.USER
          AV = Y.REL.INIT
          ETEXT = 'EB-REL.USER2'
!PACS00023889-S
!CALL STORE.END.ERROR
!PACS00023889-E
        END
        Y.EXIST.INIT++
      REPEAT
    END

    Y.REL.INIT++

  REPEAT


  RETURN

END
