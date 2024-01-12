* @ValidationCode : MjoxMDE5MjAyNTk3OkNwMTI1MjoxNzAzODUzOTE3ODk3OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 29 Dec 2023 18:15:17
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
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
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*10-04-2023            Conversion Tool             R22 Auto Code conversion                          VM TO @VM
*10-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*---------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.SECURITY.MASTER
    $INSERT I_F.REDO.L.SC.TRNYIELD.CHANGE
    $USING EB.LocalReferences
    $USING AC.API
    AC.API.EbAccounting(Pgm, Type, Entries, Forward)

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
*CALL GET.LOC.REF(LREF.APPL,LREF.FIELD,Y.TRN.POS)
    EB.LocalReferences.GetLocRef(LREF.APPL,LREF.FIELD,Y.TRN.POS) ;*R22 MANUAL CODE CONVERSION

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

*CALL F.READ(FN.REDO.L.SC.TRNYIELD.CHANGE,Y.TRN.ID,R.REDO.L.SC.TRNYIELD.CHANGE,F.REDO.L.SC.TRNYIELD.CHANGE,Y.ACC.ERR)
    CALL F.READU(FN.REDO.L.SC.TRNYIELD.CHANGE,Y.TRN.ID,R.REDO.L.SC.TRNYIELD.CHANGE,F.REDO.L.SC.TRNYIELD.CHANGE,Y.ACC.ERR,'');*R22 MANUAL CODE CONVERSION
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
        Y.CNT = DCOUNT(R.REDO.L.SC.TRNYIELD.CHANGE<SC.YLD.NEW.YIELD>,@VM)
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
