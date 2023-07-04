* @ValidationCode : MjozNTk2MTYzMTY6Q3AxMjUyOjE2ODA2MDA3MTM5NjA6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 04 Apr 2023 15:01:53
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE APAP.H.GARNISH.DETAILS.VALIDATE
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :APAP.H.GARNISH.DETAILS.VALIDATE
*---------------------------------------------------------------------------------

*DESCRIPTION       :This Template is to store the garnish information

* ----------------------------------------------------------------------------------
* Date           Who       Issue                    Desc
*01 Jun 2011     Prabhu N  PACS00071064             amended to change AMOUNT.LOCKED.VAR
* Date                  who                   Reference              
* 04-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 04-04-2023          ANIL KUMAR B      R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.APAP.H.GARNISH.DETAILS

    GOSUB PROCESS
RETURN

PROCESS:
    AMOUNT.LOCKED.VAR=R.NEW(APAP.GAR.AMOUNT.LOCKED)
    UNLOCKED.AMT.VAR=R.NEW(APAP.GAR.GARNISH.AMT.DEL)<1,1>
    R.NEW(APAP.GAR.UNLOCKED.AMT)=R.OLD(APAP.GAR.UNLOCKED.AMT)+R.NEW(APAP.GAR.GARNISH.AMT.DEL)<1,1>

*** Start PACS00592531
*  Y.UNLOCKED.AMT=FMT(R.NEW(APAP.GAR.UNLOCKED.AMT),"R2#20")
    Y.UNLOCKED.AMT = TRIM(R.NEW(APAP.GAR.UNLOCKED.AMT), "", "D")
    R.NEW(APAP.GAR.UNLOCKED.AMT) = Y.UNLOCKED.AMT
*** End PACS00592531

    IF UNLOCKED.AMT.VAR GT AMOUNT.LOCKED.VAR THEN
        AF=APAP.GAR.UNLOCKED.AMT
        ETEXT="EB-AMT.NOT.GREATER"
        CALL STORE.END.ERROR
    END
RETURN
END
