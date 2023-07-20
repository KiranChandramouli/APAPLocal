* @ValidationCode : MjotMTU5NzI5NTQ0OkNwMTI1MjoxNjg5ODMxOTE4Mzg0OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 20 Jul 2023 11:15:18
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM

SUBROUTINE REDO.CONV.ACTUAL.VERSION.NAME
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is attached as a conversion routine to the enquiry
* display the field description of EB.LOOKUP instead of the ID.
*-------------------------------------------------------------------------
* HISTORY:
*---------
*   Date               who           Reference            Description

* 07-03-2012         RIYAS           ODR-2012-03-0162     Initial Creation
*13/07/2023        CONVERSION TOOL                        AUTO R22 CODE CONVERSION -FM to @FM,VM to @VM
*13/07/2023        VIGNESHWARI                            MANUAL R22 CODE CONVERSION- Variable is changed
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.AUT.INP.VERSION.NAME
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.T24.FUND.SERVICES
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------


*  CALL F.READ(FN.REDO.AUT.INP.VERSION.NAME,'SYSTEM',R.REDO.AUT.INP.VERSION.NAME,F.REDO.AUT.INP.VERSION.NAME,VER.ERR) ;*Tus Start
    CALL CACHE.READ(FN.REDO.AUT.INP.VERSION.NAME,'SYSTEM',R.REDO.AUT.INP.VERSION.NAME,VER.ERR) ; * Tus End
  
    Y.INP.VERSION.NAME  = R.REDO.AUT.INP.VERSION.NAME<REDO.PRE.INP.VER.NAME>;*MANUAL R22 CODE CONVERSION-'REDO.PRE.INP.VERSION.NAME' to 'REDO.PRE.INP.VER.NAME'
    CHANGE @VM TO @FM IN Y.INP.VERSION.NAME
    
    Y.AUTH.VERSION.NAME = R.REDO.AUT.INP.VERSION.NAME<REDO.PRE.AUTH.VER.NAME>;*MANUAL R22 CODE CONVERSION-'REDO.PRE.AUTH.VER.NAME' to 'REDO.PRE.AUTH.VERSION.NAME'
    CHANGE @VM TO @FM IN Y.AUTH.VERSION.NAME

    CALL F.READ(FN.TELLER.NAU,O.DATA,R.TELLER.NAU,F.TELLER.NAU,TELLER.ERR)
    Y.VERSION.NAME  = R.TELLER.NAU<TT.TE.LOCAL.REF,LOC.TT.VER.POS>
    IF TELLER.ERR THEN
        CALL F.READ(FN.FUNDS.TRANSFER.NAU,O.DATA,R.FUNDS.TRANSFER.NAU,F.FUNDS.TRANSFER.NAU,FUNDS.TRANSFER.ERR)
        Y.VERSION.NAME  = R.FUNDS.TRANSFER.NAU<FT.LOCAL.REF,LOC.FT.VER.POS>
        Y.LN.ST = LEN(Y.VERSION.NAME)
        Y.LST.2 = Y.VERSION.NAME[Y.LN.ST-2,2]
        IF Y.LST.2 EQ '.A' THEN
            Y.VR.ID = Y.VERSION.NAME[1,-3]
            CALL F.READ(FN.REDO.NV.DUP.VERSION,Y.VR.ID,R.REDO.NV.DUP.VERSION,F.REDO.NV.DUP.VERSION,DUP.ERR)
            IF R.REDO.NV.DUP.VERSION THEN
                Y.VERSION.NAME = Y.VERSION.NAME[1,-3]
            END
        END
    END ELSE
        Y.LN.ST = LEN(Y.VERSION.NAME)
        Y.LST.2 = Y.VERSION.NAME[Y.LN.ST-2,2]
        IF Y.LST.2 EQ '.A' THEN
            Y.VR.ID = Y.VERSION.NAME[1,-3]
            CALL F.READ(FN.REDO.NV.DUP.VERSION,Y.VR.ID,R.REDO.NV.DUP.VERSION,F.REDO.NV.DUP.VERSION,DUP.ERR)
            IF R.REDO.NV.DUP.VERSION THEN
                Y.VERSION.NAME = Y.VERSION.NAME[1,-3]
            END
        END
    END

    IF O.DATA[1,5] EQ 'T24FS' AND TELLER.ERR AND FUNDS.TRANSFER.ERR THEN
        CALL F.READ(FN.T24.FUND.SERVICES$NAU,O.DATA,R.TFS$NAU,F.T24.FUND.SERVICES$NAU,TFS.ERR)
        Y.VERSION.NAME = R.TFS$NAU<TFS.LOCAL.REF,LOC.TFS.VER.POS>
    END

    LOCATE Y.VERSION.NAME IN Y.INP.VERSION.NAME SETTING Y.POS THEN
        O.DATA = Y.AUTH.VERSION.NAME<Y.POS>
        IF NOT(O.DATA) THEN
            O.DATA = Y.VERSION.NAME
        END
    END

RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    LREF.APP = 'FUNDS.TRANSFER':@FM:'TELLER':@FM:'T24.FUND.SERVICES'
    LREF.FIELDS = 'L.ACTUAL.VERSIO':@FM:'L.ACTUAL.VERSIO':@FM:'L.T24FS.TRA.DAY'
    LREF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    LOC.FT.VER.POS = LREF.POS<1,1>
    LOC.TT.VER.POS = LREF.POS<2,1>
    LOC.TFS.VER.POS= LREF.POS<3,1>
RETURN
*-----------------------------------------------------------------------------
OPEN.FILES:
*-----------------------------------------------------------------------------
    FN.FUNDS.TRANSFER.NAU = 'F.FUNDS.TRANSFER$NAU'
    F.FUNDS.TRANSFER.NAU = ''
    CALL OPF(FN.FUNDS.TRANSFER.NAU,F.FUNDS.TRANSFER.NAU)

    FN.TELLER.NAU = 'F.TELLER$NAU'
    F.TELLER.NAU = ''
    CALL OPF(FN.TELLER.NAU,F.TELLER.NAU)

    FN.T24.FUND.SERVICES$NAU = 'F.T24.FUND.SERVICES$NAU'
    F.T24.FUND.SERVICES$NAU = ''
    CALL OPF(FN.T24.FUND.SERVICES$NAU,F.T24.FUND.SERVICES$NAU)

    FN.REDO.AUT.INP.VERSION.NAME = 'F.REDO.AUT.INP.VERSION.NAME'
    F.REDO.AUT.INP.VERSION.NAME = ''
    CALL OPF(FN.REDO.AUT.INP.VERSION.NAME,F.REDO.AUT.INP.VERSION.NAME)

    FN.REDO.NV.DUP.VERSION = 'F.REDO.NV.DUP.VERSION'
    F.REDO.NV.DUP.VERSION = ''
    CALL OPF(FN.REDO.NV.DUP.VERSION,F.REDO.NV.DUP.VERSION)

RETURN
*-----------------------------------------------------------------------------
END
