*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CONV.ARR.TO.AC

*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :MARIMUTHU S
*Program   Name    :REDO.CONV.ARR.TO.AC
*---------------------------------------------------------------------------------

*DESCRIPTION       : This is conversion routine used in the enquiry REDO.PART.TT.PROCESS.LIST

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 10-08-2010        MARIMUTHU S      PACS00094144       Initial Creation

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.AA.ARRANGEMENT


  FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
  F.AA.ARRANGEMENT = ''
  CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)


  Y.ID = O.DATA
  IF Y.ID[1,2] EQ 'AA' THEN
    CALL F.READ(FN.AA.ARRANGEMENT,Y.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ERR)
    O.DATA = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
  END

  RETURN

END
