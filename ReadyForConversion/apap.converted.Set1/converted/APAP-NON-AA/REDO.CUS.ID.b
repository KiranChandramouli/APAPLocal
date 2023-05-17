SUBROUTINE REDO.CUS.ID
*-----------------------------------------------------------------------------
*Date Name Ref.ID Description
*15-07-2011 Sudharsanan S PACS00087225 Initial Creation
*-------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_GTS.COMMON
    $INSERT I_REDO.V.VAL.CED.IDENT.COMMON
    IF V$FUNCTION EQ 'I' THEN
        GOSUB OPENFILES
        GOSUB PROCESS
    END
RETURN
*------------------------------------------------------------------------
OPENFILES:
*------------------------------------------------------------------------
    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    FN.CUSTOMER$NAU='F.CUSTOMER$NAU'
    F.CUSTOMER$NAU=''
    CALL OPF(FN.CUSTOMER$NAU,F.CUSTOMER$NAU)
RETURN
*-------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------
    CALL F.READ(FN.CUSTOMER$NAU,COMI,R.CUS.LOC,F.CUSTOMER$NAU,ERR)
    IF R.CUS.LOC EQ '' THEN
        CALL F.READ(FN.CUSTOMER,COMI,R.CUS.LOC,F.CUSTOMER,ERR)
    END
    IF GTSACTIVE THEN
        IF OFS$OPERATION EQ 'BUILD' THEN
            LOC.REF.POS = ''
            CALL GET.LOC.REF('CUSTOMER','L.CU.CIDENT',LOC.REF.POS)
            VAR.INTERFACE.RNC=''
            Y.LOC.SPARE=R.CUS.LOC<EB.CUS.LOCAL.REF><1,LOC.REF.POS>
            LOC.INTERFACE=''
        END
    END
RETURN
*---------------------------------------------------------------------------
END
