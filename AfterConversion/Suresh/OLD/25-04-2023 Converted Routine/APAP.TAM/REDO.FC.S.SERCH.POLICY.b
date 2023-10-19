* @ValidationCode : MjotMTAzMzE2MTYxMjpDcDEyNTI6MTY4MjQyMTAxMTc5MDozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 16:40:11
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.FC.S.SERCH.POLICY(Y.POLICY.TYPE)
*------------------------------------------------------------------------------------------------------------------
* Developer    : mgudino@temenos.com
* Date         : 2011-06-13
* Description  : This routine its on charge TO SEARCH THE CORRECT POLICY FROM DETERMIN COLL
*
*------------------------------------------------------------------------------------------------------------------
* Input/Output:
* -------------
* In  :
*      Y.POLICY.TYPE
* Out :
*
*------------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Version          Date          Name              Description
* -------          ----          ----              ------------
* 1.0              2011-07-11   Marcelo Gudino   First Version
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION           FM TO @FM, K TO K.VAR
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CREATE.ARRANGEMENT


    GOSUB INITIALISE

    GOSUB PROCESS


RETURN

*------------------------------------------------------------------------------------------------------------------
* <region name=PROCESS>
PROCESS:
*
*------------------------------------------------------------------------------------------------------------------
*
    GOSUB BUSCA.POLIZA

RETURN
* </region>
*------------------------------------------------------------------------------------------------------------------

*------------------------------------------------------------------------------------------------------------------
* <region name=BUSCA.POLIZA>
BUSCA.POLIZA:
* do the searh to Policy type, when is needed by the the COLL type
*------------------------------------------------------------------------------------------------------------------

    LOCATE Y.POLICY.TYPE IN R.NEW(REDO.FC.INS.POLICY.TYPE)<1,1> SETTING K.VAR THEN ;*AUTO R22 CODE CONVERSION
        RETURN          ;* CASO EXITO
    END ELSE
        ETEXT = 'EB-FC-COLL-POLICY': @FM : Y.POLICY.TYPE
        CALL STORE.END.ERROR
        RETURN
    END

RETURN
* </region>
*------------------------------------------------------------------------------------------------------------------

*------------------------------------------------------------------------------------------------------------------
* <region name=INITIALISE>
INITIALISE:
*------------------------------------------------------------------------------------------------------------------

RETURN
* </region>


*------------------------------------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------------------------------
END
