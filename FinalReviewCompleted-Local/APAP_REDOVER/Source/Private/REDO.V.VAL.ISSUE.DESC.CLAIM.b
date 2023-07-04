* @ValidationCode : MjotMTQ4MTQyOTY3ODpDcDEyNTI6MTY4MjQxMjM2MjE1ODpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:16:02
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.ISSUE.DESC.CLAIM
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : A validation routine is written to update the DESCRIPTION.CLAIM field from
*the local table REDO.SLA.PARAM
*
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.V.VAL.ISSUE.DESC.CLAIM
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 27.07.2010      SUDHARSANAN S     ODR-2009-12-0283  INITIAL CREATION
* 01-MAR-2010      PRABHU              HD1100464      Other product type account not required
* ----------------------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*17-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM
*17-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*-------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.ISSUE.CLAIMS
    $INSERT I_F.REDO.SLA.PARAM

    GOSUB INIT
    GOSUB PROCESS
RETURN
*------------------------------------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------------------------------------
    FN.REDO.ISSUE.CLAIMS = 'F.REDO.ISSUE.CLAIMS'
    F.REDO.ISSUE.CLAIMS  = ''
    CALL OPF(FN.REDO.ISSUE.CLAIMS, F.REDO.ISSUE.CLAIMS)

    FN.REDO.SLA.PARAM = 'F.REDO.SLA.PARAM'
    F.REDO.SLA.PARAM = ''
    CALL OPF(FN.REDO.SLA.PARAM,F.REDO.SLA.PARAM)

RETURN
*--------------------------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------------------------

    IF AF EQ ISS.CL.PRODUCT.TYPE THEN
        IF (VAL.TEXT) AND COMI NE 'OTROS' AND R.NEW(ISS.CL.ACCOUNT.ID) EQ '' THEN
            ETEXT="EB-ACCT.NO.MAND"
            CALL STORE.END.ERROR
        END
        Y.PRDT.TYPE = COMI
        Y.TYPE = R.NEW(ISS.CL.TYPE)
        Y.ID = Y.TYPE:'-':Y.PRDT.TYPE
        IF Y.TYPE NE '' THEN
            GOSUB DES.CLAIM
        END
    END
    IF AF EQ ISS.CL.TYPE THEN
        Y.PRDT.TYPE = R.NEW(ISS.CL.PRODUCT.TYPE)
        Y.TYPE = COMI
        IF Y.TYPE EQ 'RECLAMACION' THEN
            Y.ID = Y.TYPE:'-':Y.PRDT.TYPE
            IF Y.PRDT.TYPE NE '' THEN
                GOSUB DES.CLAIM
            END
        END ELSE
            AF = ISS.CL.TYPE
            ETEXT ='EB-NOT.VALID.TYPE'
            CALL STORE.END.ERROR
        END
    END
RETURN
*-------------------------------------------------------------------------------------------
DES.CLAIM:
*-------------------------------------------------------------------------------------------

    CALL F.READ(FN.REDO.SLA.PARAM,Y.ID,R.SLA.PARAM,F.REDO.SLA.PARAM,PARA.ERR)
    IF R.SLA.PARAM THEN
        R.NEW(ISS.CL.SLA.ID) = Y.ID
    END ELSE
        AF = ISS.CL.PRODUCT.TYPE
        ETEXT ='EB-NOT.VALID.PRODUCT':@FM:Y.PRDT.TYPE:@VM:Y.TYPE
        CALL STORE.END.ERROR
    END
RETURN
*----------------------------------------------------------------------------------------------
END
