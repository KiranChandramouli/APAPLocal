*-----------------------------------------------------------------------------
* <Rating>-34</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.E.CONV.SEL.CRIT.66
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    : REDO.APAP.E.CONV.SEL.CRIT.66
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.E.CONV.SEL.CRIT.66 is a conversion routine attached to the enquiries
*                    REDO.APAP.ENQ.EMP.ACCT.RPT and REDO.APAP.ER.EMP.ACCT.RPT the routine fetches
*                    the value from ENQ.SELECTION formats them according to the selection criteria and returns
*                    the value back to O.DATA
*In Parameter      : N/A
*Out Parameter     : O.DATA
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date             Who                      Reference                 Description
*   ------          ------                     -------------             -------------
*  16 Nov 2010      Shiva Prasad Y                                      Initial Creation
*
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.USER
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
  GOSUB PROCESS.PARA

  RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
  Y.CRITERIA = ''

  LOCATE 'TIPO.DE.CUENTA' IN ENQ.SELECTION<2,1> SETTING Y.TIPO.POS THEN
    Y.CRITERIA := 'Tipo De Cuenta es igual a ':ENQ.SELECTION<4,Y.TIPO.POS>
  END

  LOCATE 'ESTATUS.CIERRE' IN ENQ.SELECTION<2,1> SETTING Y.ESTAT.C.POS THEN
    IF Y.CRITERIA THEN
      Y.CRITERIA := ', Estatus Cierre es igual a ':ENQ.SELECTION<4,Y.ESTAT.C.POS>
    END ELSE
      Y.CRITERIA := 'Estatus Cierre es igual a ':ENQ.SELECTION<4,Y.ESTAT.C.POS>
    END
  END

  LOCATE 'ESTATUS.1' IN ENQ.SELECTION<2,1> SETTING Y.ESTAT1.POS THEN
    LOOKUP.ID = 'L.AC.STATUS1'
    Y.VALUE = ENQ.SELECTION<4,Y.ESTAT1.POS>
    GOSUB RETRIEVE.SPANISH.DESC
    ENQ.SELECTION<4,Y.ESTAT1.POS>=Y.VALUE
    IF Y.CRITERIA THEN
      Y.CRITERIA := ', Estatus 1 es igual a ':ENQ.SELECTION<4,Y.ESTAT1.POS>
    END ELSE
      Y.CRITERIA := 'Estatus 1 es igual a ':ENQ.SELECTION<4,Y.ESTAT1.POS>
    END
  END

  LOCATE 'ESTATUS.2' IN ENQ.SELECTION<2,1> SETTING Y.ESTAT2.POS THEN
    Y.VALUE = ''
    LOOKUP.ID = 'L.AC.STATUS2'
    Y.VALUE = ENQ.SELECTION<4,Y.ESTAT2.POS>
    GOSUB RETRIEVE.SPANISH.DESC
    ENQ.SELECTION<4,Y.ESTAT2.POS> = Y.VALUE
    IF Y.CRITERIA THEN
      Y.CRITERIA := ', Estatus 2 es igual a ':ENQ.SELECTION<4,Y.ESTAT2.POS>
    END ELSE
      Y.CRITERIA := 'Estatus 2 es igual a ':ENQ.SELECTION<4,Y.ESTAT2.POS>
    END
  END

  O.DATA =  Y.CRITERIA

  RETURN

RETRIEVE.SPANISH.DESC:
* Fix for PACS00312026

  VIRTUAL.TAB.ID=LOOKUP.ID
  CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID)
  Y.LOOKUP.LIST=VIRTUAL.TAB.ID<2>
  Y.LOOKUP.DESC=VIRTUAL.TAB.ID<11>
  CHANGE '_' TO FM IN Y.LOOKUP.LIST
  CHANGE '_' TO FM IN Y.LOOKUP.DESC

  LOCATE Y.VALUE IN Y.LOOKUP.LIST SETTING POS1 THEN
    IF R.USER<EB.USE.LANGUAGE> EQ 1 THEN          ;* This is for english user
      Y.VALUE=Y.LOOKUP.DESC<POS1,1>
    END
    IF R.USER<EB.USE.LANGUAGE> EQ 2 AND Y.LOOKUP.DESC<POS1,2> NE '' THEN
      Y.VALUE=Y.LOOKUP.DESC<POS1,2>     ;* This is for spanish user
    END ELSE
      Y.VALUE=Y.LOOKUP.DESC<POS1,1>
    END
  END

* End of Fix
  RETURN

*--------------------------------------------------------------------------------------------------------
END
