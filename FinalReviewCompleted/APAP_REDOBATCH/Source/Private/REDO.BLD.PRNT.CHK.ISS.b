* @ValidationCode : MjotNjgzMTkwODY4OkNwMTI1MjoxNjg0ODU0NDA0MjAzOklUU1M6LTE6LTE6Mjg3OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 287
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.BLD.PRNT.CHK.ISS(ENQ.DATA)
*-----------------------------------------------------------------------------
* Modification History:
*----------------------
* DATE            ODR           BY              DESCRIPTION
*-----            ---           --              -----------
* 31-01-2012    PACS00130539   SHANNKAR RAJU   For enquiry REDO.SOLICITUD.CK.ORDIM
* Date                  who                   Reference              
* 17-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - FM TO @FM AND SM TO @SM
* 17-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ENQUIRY
    $INSERT I_F.REDO.H.SOLICITUD.CK

    GOSUB INITIALISE
    GOSUB PROCESS
*
RETURN

INITIALISE:
*************

    FN.REDO.H.SOLICITUD.CK = 'F.REDO.H.SOLICITUD.CK'
    F.REDO.H.SOLICITUD.CK  = ''
    CALL OPF(FN.REDO.H.SOLICITUD.CK,F.REDO.H.SOLICITUD.CK)

    FN.REDO.H.SOLICITUD.CK.NAU = 'F.REDO.H.SOLICITUD.CK$NAU'
    F.REDO.H.SOLICITUD.CK.NAU  = ''
    R.REDO.H.SOLICITUD.CK.NAU  = ''
    CALL OPF(FN.REDO.H.SOLICITUD.CK.NAU,F.REDO.H.SOLICITUD.CK.NAU)

RETURN

PROCESS:
********

    Y.SUC.SOL   = ENQ.DATA<4,1>
    Y.DATE.TIME = ENQ.DATA<4,2>

    SEL.CMD = "SELECT ":FN.REDO.H.SOLICITUD.CK:" WITH CHEQUE.STATUS EQ 10"

    IF Y.SUC.SOL THEN
        SEL.CMD:= " AND SUC.SOL EQ ":Y.SUC.SOL
    END

    IF Y.DATE.TIME THEN
        SEL.CMD:= " AND DATE.TIME EQ ":Y.DATE.TIME
    END

    CALL EB.READLIST(SEL.CMD,SEL.LIST1,'',SEL.NOR1,SEL.RET1)


    Y.NO.LP = 1

    LOOP
    WHILE Y.NO.LP LE SEL.NOR1
        Y.SOLICIT.ID = SEL.LIST1<Y.NO.LP>
        CALL F.READ(FN.REDO.H.SOLICITUD.CK.NAU,Y.SOLICIT.ID,R.REDO.H.SOLICITUD.CK.NAU,F.REDO.H.SOLICITUD.CK.NAU,ERR.SOLIC)
        IF R.REDO.H.SOLICITUD.CK.NAU ELSE
            Y.SEL.ID<-1> = Y.SOLICIT.ID
        END
        Y.NO.LP += 1

    REPEAT

    CHANGE @FM TO @SM IN Y.SEL.ID

    ENQ.DATA<2,1> = "@ID"
    ENQ.DATA<3,1> = "EQ"
    ENQ.DATA<4,1> = Y.SEL.ID

RETURN
END
