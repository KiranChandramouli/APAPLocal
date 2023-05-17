*-----------------------------------------------------------------------------
* <Rating>-35</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.R.BCR.REPORT.GEN.LIST.BUILD
*-----------------------------------------------------------------------------
* INTERFACE : REDO.BCR.REPORT : Buro de Credito
* This routine selects the list of ID's from REDO.INTERFACE.PARAM, whom are
* to be processed in the COB
* Basically, this routine executes
* SELECT F.REDO.INTERFACE.PARAM WITH @ID LIKE BCR... AND AUTOM.EXEC EQ SI
*        AND AUTOM.EXEC.FREC LIKE TODAY...
* Finally, the routine writes COB*BCR*REDO.INTERFACE.PARAM entry into F.LOCKING
* ant its content is the list of ID's to process
* @author youremail@temenos.com
* @stereotype subroutine
* @package REDO.BCR
*!
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.LOCKING

*-----------------------------------------------------------------------------
	FN.LOCKING='F.LOCKING'         
	F.LOCKING = ''                 
	CALL OPF(FN.LOCKING, F.LOCKING)
	
  GOSUB INITIALISE
  GOSUB PROCESS

  RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

  R.LOCKING = ''
  Y.LOKING.ID = "COB*BCR*REDO.INTERFACE.PARAM"
  CALL OCOMO("GENERANDO LA LISTA DE REDO.INTERFACE.PARAM - BURO DE CREDITO A GENERAR")
  READ R.LOCKING FROM F.LOCKING, Y.LOKING.ID THEN
* In this case, just the field content must be empty
  END

  NO.OF.RECS = 0
  Y.KEY.LIST = ''
  Y.SEL.CMD = ''
  Y.SEL.CMD := 'SELECT ' : FN.REDO.INT.PARAM
  Y.SEL.CMD := ' WITH @ID LIKE BCR... AND AUTOM.EXEC.FREC LIKE '
  Y.SEL.CMD := TODAY : '...'
  Y.SEL.CMD := ' AND AUTOM.EXEC EQ SI'

  CALL EB.READLIST(Y.SEL.CMD, Y.KEY.LIST, '', NO.OF.RECS, SYSTEM.RETURN.CODE)

  Y.KEY.LIST = CHANGE(Y.KEY.LIST, FM, VM)
  R.LOCKING<EB.LOK.CONTENT> = Y.KEY.LIST  ;*Tus Start
  R.LOCKING<EB.LOK.REMARK,1> = "BURO DE CREDITO "  
  R.LOCKING<EB.LOK.REMARK,2> = "ID'S LIST FROM REDO.INTERFACE.PARAM TO PROCESS "  
  R.LOCKING<EB.LOK.REMARK,3> = "LAST UPDATE: " : TODAY  
*  WRITE R.LOCKING TO F.LOCKING, Y.LOKING.ID 
  CALL F.WRITE(FN.LOCKING,Y.LOKING.ID,R.LOCKING)  ;*Tus End
IF NOT(PGM.VERSION) AND NOT(RUNNING.UNDER.BATCH) THEN
CALL JOURNAL.UPDATE('')
END

  RETURN

*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------

* F.LOCKING is a common variable on I_COMMON file
*      FN.LOCKING = 'F.LOCKING'
*      F.LOCKING  = ''
*      CALL OPF(FN.LOCKING, F.LOCKING)

  FN.REDO.INT.PARAM = 'F.REDO.INTERFACE.PARAM'
  F.REDO.INT.PARAM  = ''
  CALL OPF(FN.REDO.INT.PARAM, F.REDO.INT.PARAM)

  RETURN

*-----------------------------------------------------------------------------
END
