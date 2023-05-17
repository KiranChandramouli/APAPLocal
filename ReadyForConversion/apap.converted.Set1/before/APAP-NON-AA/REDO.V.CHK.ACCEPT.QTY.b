*-----------------------------------------------------------------------------
* <Rating>-12</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.CHK.ACCEPT.QTY(CARD.REQ,CARD.TYPES,TOT.CARD.CNT,CARD.TYPE.FLD)

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.CARD.REQUEST
$INSERT I_REDO.CRD.DMG.LST.COMMON
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.V.CHK.ACCEPT.QTY
*--------------------------------------------------------------------------------------------------------
*Description  : This routine can be used to throw error when the card marked for Damage/Lost is greater than the
*card accepted
*Linked With  : Application REDO.CARD.DMG.EMBOSS
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 19 MAY 2011     Balagurunathan               ODR-2010-03-0400        Initail Draft
*--------------------------------------------------------------------------------------------------------
*REDO.CARD.REQ.CARD.TYPE
*REDO.CARD.REQ.BRANCH.ORDERQTY
*REDO.CARD.REQ.REGOFF.ACCEPTQTY


  FN.REDO.CARD.REQUEST='F.REDO.CARD.REQUEST'
  F.REDO.CARD.REQUEST=''
  CALL OPF(FN.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST)

  CALL F.READU(FN.REDO.CARD.REQUEST,CARD.REQ,R.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST,REQ.ERR,'P')


  REQ.TYPE=R.REDO.CARD.REQUEST<REDO.CARD.REQ.CARD.TYPE>
  ACPT.QTY=R.REDO.CARD.REQUEST<REDO.CARD.REQ.REGOFF.ACCEPTQTY>

  LOOP.POS=1
  LOOP
    REMOVE TYPE.CRD FROM CARD.TYPES SETTING POS.CRD

  WHILE TYPE.CRD:POS.CRD

    LOCATE TYPE.CRD IN REQ.TYPE<1,1> SETTING TYPE.POS THEN

      QTY.CARD=ACPT.QTY<1,TYPE.POS>
      IF QTY.CARD LT TOT.CARD.CNT<LOOP.POS> THEN
        AF=CARD.TYPE.FLD
        AV=LOOP.POS

        ETEXT='"ST-QTY.ACCEPTED.L.QTY.ENTRY"'
        CALL STORE.END.ERROR
        RETURN
      END

    END ELSE
      AF=CARD.TYPE.FLD
      AV=LOOP.POS

      ETEXT='ST-CARD.TYPE.NOT.REQUESTED'
      CALL STORE.END.ERROR
      RETURN
    END

    LOOP.POS=LOOP.POS+1
  REPEAT



  RETURN

END
