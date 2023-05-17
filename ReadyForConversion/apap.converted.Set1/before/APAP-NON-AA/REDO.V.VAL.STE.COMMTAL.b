*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.V.VAL.STE.COMMTAL
*------------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: S SUDHARSANAN
* PROGRAM NAME: REDO.V.VAL.STE.COMMTAL
* ODR NO : ODR-2009-12-0275
*----------------------------------------------------------------------
* DESCRIPTION: This routine will populate the value for the field
* L.STE.COMMTAL has to be brought automatically from the field COMMISSION
* in the table REDO.H.MOD.CHEQUERA
* IN PARAMETER:NONE
* OUT PARAMETER:NONE
* LINKED WITH:STOCK.ENTRY,REDO.PERSONALIZACION
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE WHO REFERENCE DESCRIPTION
*15.02.2010 S SUDHARSANAN ODR-2009-12-0275 INITIAL CREATION
*----------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.STOCK.ENTRY
$INSERT I_F.REDO.H.MOD.CHEQUERA
GOSUB INIT
GOSUB PROCESS
RETURN
******
INIT:
******
FN.STOCK.ENTRY='F.STOCK.ENTRY'
F.STOCK.ENTRY=''
CALL OPF(FN.STOCK.ENTRY,F.STOCK.ENTRY)
FN.REDO.H.MOD.CHEQUERA='F.REDO.H.MOD.CHEQUERA'
F.REDO.H.MOD.CHEQUERA=''
CALL OPF(FN.REDO.H.MOD.CHEQUERA,F.REDO.H.MOD.CHEQUERA)
STE.COMM.POS=''
CALL GET.LOC.REF("STOCK.ENTRY",'L.STE.COMMTAL',STE.COMM.POS)
RETURN
********
PROCESS:
*********
* Default the field L.STE.COMMTAL

MOD.CHEQ.ID = COMI
CALL F.READ(FN.REDO.H.MOD.CHEQUERA,MOD.CHEQ.ID,R.REDO.H.MOD.CHEQUERA,F.REDO.H.MOD.CHEQUERA,CHEQ.ERR)
IF CHEQ.ERR EQ '' THEN
COMM.CNT=DCOUNT(R.REDO.H.MOD.CHEQUERA<REDO.H.MOD.COMMISSION>,VM)
COMM.POS=1
LOOP
WHILE COMM.POS LE COMM.CNT
R.NEW(STO.ENT.LOCAL.REF)<1,STE.COMM.POS,COMM.POS> = R.REDO.H.MOD.CHEQUERA<REDO.H.MOD.COMMISSION,COMM.POS>
COMM.POS++
REPEAT
END
RETURN
*------------------------------------------------------------------
END
