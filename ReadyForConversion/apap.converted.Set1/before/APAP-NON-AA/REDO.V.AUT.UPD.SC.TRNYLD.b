*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.V.AUT.UPD.SC.TRNYLD
*--------------------------------------------------------------------------------
*Company Name :Asociacion Popular de Ahorros y Prestamos
*Developed By :RIYAS AHAMAD BASHA J
*Program Name :REDO.V.AUT.UPD.SC.TRNYLD
*---------------------------------------------------------------------------------

*DESCRIPTION : This routine will update the table REDO.L.SC.TRNYIELD.CHANGE
* when the yield price (L.SC.TRN.YIELD) in the SECURITY.MASTER
* record is changed
* ----------------------------------------------------------------------------------
*MODIFICATION DETAILS
*====================
* Date who Reference Description
* 15-NOV-2010 Riyas Ahamad Basha J ODR-2009-07-0083 Initial Creation
*-----------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.SECURITY.MASTER
$INSERT I_F.REDO.L.SC.TRNYIELD.CHANGE

GOSUB INIT
GOSUB PROCESS
RETURN
*----
INIT:
*----

FN.REDO.L.SC.TRNYIELD.CHANGE='F.REDO.L.SC.TRNYIELD.CHANGE'
F.REDO.L.SC.TRNYIELD.CHANGE=''
R.REDO.L.SC.TRNYIELD.CHANGE = ''
Y.ACC.ERR = ''
CALL OPF(FN.REDO.L.SC.TRNYIELD.CHANGE,F.REDO.L.SC.TRNYIELD.CHANGE)

Y.CNT = 0
LREF.APPL='SECURITY.MASTER'
LREF.FIELD='L.SC.TRN.YIELD'
Y.TRN.POS=''
CALL GET.LOC.REF(LREF.APPL,LREF.FIELD,Y.TRN.POS)

RETURN

*---------
PROCESS:
*---------

Y.TRN.ID=ID.NEW:".":TODAY
Y.NEW.YLD=R.NEW(SC.SCM.LOCAL.REF)<1,Y.TRN.POS>
Y.OLD.YLD=R.OLD(SC.SCM.LOCAL.REF)<1,Y.TRN.POS>
Y.TIME = OCONV(TIME(),'MTS')

IF Y.OLD.YLD EQ '' THEN
Y.OLD.YLD = 0
END
IF Y.NEW.YLD EQ '' THEN
Y.NEW.YLD = 0
END

CALL F.READ(FN.REDO.L.SC.TRNYIELD.CHANGE,Y.TRN.ID,R.REDO.L.SC.TRNYIELD.CHANGE,F.REDO.L.SC.TRNYIELD.CHANGE,Y.ACC.ERR)
R.REDO.L.SC.TRNYIELD.CHANGE<SC.YLD.SECURITY.NO> = ID.NEW
R.REDO.L.SC.TRNYIELD.CHANGE<SC.YLD.DATE.CHANGE> = TODAY

IF R.REDO.L.SC.TRNYIELD.CHANGE EQ '' THEN
Y.CNT +=1
R.REDO.L.SC.TRNYIELD.CHANGE<SC.YLD.NEW.YIELD,Y.CNT> = Y.NEW.YLD
R.REDO.L.SC.TRNYIELD.CHANGE<SC.YLD.OLD.YIELD,Y.CNT> = Y.OLD.YLD
R.REDO.L.SC.TRNYIELD.CHANGE<SC.YLD.TIME.CHANGE,Y.CNT> = Y.TIME
R.REDO.L.SC.TRNYIELD.CHANGE<SC.YLD.INP.USER,Y.CNT> = OPERATOR
CALL F.WRITE(FN.REDO.L.SC.TRNYIELD.CHANGE,Y.TRN.ID,R.REDO.L.SC.TRNYIELD.CHANGE)
END

ELSE
Y.CNT = DCOUNT(R.REDO.L.SC.TRNYIELD.CHANGE<SC.YLD.NEW.YIELD>,VM)
Y.NEW.VAL.LIST = R.REDO.L.SC.TRNYIELD.CHANGE<SC.YLD.NEW.YIELD>
Y.NEW.VAL = Y.NEW.VAL.LIST<1,Y.CNT>

IF Y.NEW.VAL NE Y.NEW.YLD THEN
Y.CNT += 1
R.REDO.L.SC.TRNYIELD.CHANGE<SC.YLD.TIME.CHANGE,Y.CNT> = Y.TIME
R.REDO.L.SC.TRNYIELD.CHANGE<SC.YLD.NEW.YIELD,Y.CNT> = Y.NEW.YLD
R.REDO.L.SC.TRNYIELD.CHANGE<SC.YLD.OLD.YIELD,Y.CNT> = Y.OLD.YLD
R.REDO.L.SC.TRNYIELD.CHANGE<SC.YLD.INP.USER,Y.CNT> = OPERATOR
CALL F.WRITE(FN.REDO.L.SC.TRNYIELD.CHANGE,Y.TRN.ID,R.REDO.L.SC.TRNYIELD.CHANGE)
END
END
RETURN
*----------------------------------------------------------
END
