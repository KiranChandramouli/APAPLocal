* @ValidationCode : MjotMTAzNjczMTM2OTpDcDEyNTI6MTY4MjA3MzM4MjMxMjpJVFNTOi0xOi0xOjM4NToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Apr 2023 16:06:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 385
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.BLD.LATAM.ACTIVATION(ENQ.DATA)
*------------------------------------------------------------------------------------------------------
*DESCRIPTION
* returns the list of IDs that is created to fetch latam card id

*------------------------------------------------------------------------------------------------------
*APPLICATION
* build routine to be attached in the enquiry REDO.LATAM.CARD.ACTIVATION
*----------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Temenos Application Management
* PROGRAM NAME : REDO.E.BLD.LATAM.ACTIVATION
*----------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO               REFERENCE         DESCRIPTION
*08.03.2011      Swaminathan     ODR-2010-03-0400   INITIAL CREATION
*
* 17-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 17-APR-2023      Harishvikram C   Manual R22 conversion      No changes
* ----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.CARD.BIN

    GOSUB INIT
    GOSUB PROCESS
RETURN

*------------------------------------------------------------
INIT:
*------------------------------------------------------------
    FN.REDO.CARD.BIN = 'F.REDO.CARD.BIN'
    F.REDO.CARD.BIN = ''
    CALL OPF(FN.REDO.CARD.BIN,F.REDO.CARD.BIN)

    FN.LATAM.CARD.ORDER='F.LATAM.CARD.ORDER'
    F.LATAM.CARD.ORDER=''
    CALL OPF(FN.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER)
RETURN

*------------------------------------------------------------
PROCESS:
*------------------------------------------------------------

    Y.LCO.VAL = ENQ.DATA<4,1>
    Y.CARD.BIN = Y.LCO.VAL[1,6]
    CALL F.READ(FN.REDO.CARD.BIN,Y.CARD.BIN,R.REDO.CARD.BIN,F.REDO.CARD.BIN,Y.ERR.BIN)

    Y.CRD.TYPE= R.REDO.CARD.BIN<REDO.CARD.BIN.CARD.TYPE>

    LOOP
        REMOVE Y.CRD.TYP FROM Y.CRD.TYPE SETTING POS.CRD

    WHILE Y.CRD.TYP:POS.CRD

        CRD.NUMBER=Y.CRD.TYP:".":Y.LCO.VAL
        CALL F.READ(FN.LATAM.CARD.ORDER,CRD.NUMBER,R.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER,ERR.CRD)
        IF R.LATAM.CARD.ORDER THEN
            Y.CARD.TYPE=Y.CRD.TYP
        END
    REPEAT

    IF R.REDO.CARD.BIN NE '' THEN

        ENQ.DATA<2,1> = "@ID"
        ENQ.DATA<3,1> = "EQ"
        ENQ.DATA<4,1>  = Y.CARD.TYPE:'.':Y.LCO.VAL
    END
RETURN
*------------------------------------------------------------
END
