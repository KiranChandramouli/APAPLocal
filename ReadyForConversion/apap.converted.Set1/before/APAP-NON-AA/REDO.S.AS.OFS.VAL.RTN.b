*-----------------------------------------------------------------------------
* <Rating>-38</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.AS.OFS.VAL.RTN(OFS.REQUEST)
*-----------------------------------------------------------------------------
* Developer    : MG
*                TAM Latin America
* Client       : REDO
* Date         : 07.19.2013
* Description  : Outcome OFS tasks
* Type         : Message Routine
* Attached to  : OFS Source GCS > OUT.MSG.RTN
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date           Who            Reference         Description

*-----------------------------------------------------------------------------
* Input/Output: OFS.RESPONSE
*
* Dependencies: NA
*-----------------------------------------------------------------------------

* <region name="INCLUDES">

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.CREATE.ARRANGEMENT

* </region>

  GOSUB INIT
*    GOSUB OPEN.FILES
  GOSUB PROCESS
  RETURN

* <region name="GOSUBS" description="Gosub blocks">

***********************
* Initialize variables
INIT:
***********************
  Y.CANAL = ''
  Y.SERVICIO = ''
  Y.PRODUCTO = ''
  Y.FEC.NEGO = ''

  CS.LIST = ''
  CS.LIST.NAME = ''
  CS.SELECTED = ''
  SYSTEM.RETURN.CODE = ''

  ERR.CODE = "00"
  CLOSING.TIME = ''

  FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
  F.AA.ARRANGEMENT = ''

  Y.ERR = ''
  Y.INT.CODE = 'TWS001'
  Y.INT.TYPE = 'ONLINE'
  Y.INT.INFO = 'FC'
  Y.INT.MONT = ''
  Y.INT.DESC = ''
  Y.INT.DATA = ''
  Y.INT.USER = OPERATOR
  Y.INT.EXPC = "HOST"

  RETURN

***********************
* Open files
OPEN.FILES:
***********************
  CALL OPF(FN.AA.ARRANGEMENT , F.AA.ARRANGEMENT )

  RETURN

*********************************************************
* Main process for APP not equal to ENQUIRY.SELECT
PROCESS:
********************************************************
  IF OFS.REQUEST EQ 'SECURITY VIOLATION' OR OFS.REQUEST EQ 'SECURITY VIOLATION DURING SIGN ON PROCESS' OR OFS.REQUEST EQ 'VIOLACICN DE SEGURIDAD' OR OFS.REQUEST EQ 'INVALID/ NO SIGN...'  THEN
    Y.INT.MONT = '09'
    Y.INT.DESC = OPERATOR:' ERROR - CREDENCIALES INCORRECTAS / USUARIO EXPIRADO'
    Y.INT.DATA = ""
    CALL REDO.INTERFACE.REC.ACT(Y.INT.CODE, Y.INT.TYPE, '', '', Y.INT.INFO, Y.INT.INFO, Y.NRO.DOCUMENTO, Y.INT.MONT, Y.INT.DESC, Y.INT.DATA, Y.INT.USER, Y.INT.EXPC)
    RETURN
  END
  CALL OPF(FN.AA.ARRANGEMENT , F.AA.ARRANGEMENT )

  Y.NUM = DCOUNT(OFS.REQUEST,',')
  Y.OFS.REQUEST = OFS.REQUEST
  FOR I = 1 TO Y.NUM
    Y.AUX = Y.OFS.REQUEST[',',I,1]
    Y.POS = 0
* Search ARRANGEMENT in OFS OUTPUT message

    IF Y.AUX MATCHES '...ID.ARRANGEMENT...' THEN
      Y.ID.AA = Y.AUX['=',2,1]
      Y.POS = I
      I = Y.NUM
    END

  NEXT
*    ! choose delay
  CALL OCOMO ("LEE EL AA")
  R.AA.ARRANGEMENT = ''
  IF Y.ID.AA THEN
    CALL F.READ(FN.AA.ARRANGEMENT ,Y.ID.AA,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ARRANGEMENT.ERR)

    IF NOT(R.AA.ARRANGEMENT) THEN
* NO EXISTE
      Y.NEW.AUX = Y.AUX
      CHANGE Y.ID.AA TO 'ERROR AL CREAR PRESTAMO POR FAVOR CONSULTE EL LOG' IN Y.NEW.AUX
      CHANGE Y.AUX TO Y.NEW.AUX IN OFS.REQUEST
    END
  END

  RETURN

* </region>

END
