* @ValidationCode : MjotMjEzNjA2NzU2ODpDcDEyNTI6MTcwNDQzNjEyNjM4NDozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Jan 2024 11:58:46
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
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.RENEW.PROCESS.SELECT
********************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Swaminathan.S.R
* PROGRAM NAME: REDO.B.RENEW.PROCESS.SELECT
*------------------------------------------------------------------------------
*DESCRIPTION:This is a Multi threaded Select Routine Which is used to select
*the LATAM.CARD.ORDER ids for all companies
*-------------------------------------------------------------------------------
*IN PARAMETER: NONE
*OUT PARAMETER: NONE
*LINKED WITH: REDO.B.RENEW.PROCESS.SELECT
*-----------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE            DESCRIPTION
*07-AUG-2010    Swaminathan.S.R        ODR-2010-03-0400      INITIAL CREATION
*27 MAY 2011    KAVITHA                PACS00063156          PACS00063156 fix
* 04-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*18/01/2024         Suresh          R22 UTILITY AUTO CONVERSION  CALL routine Modified
*--------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.RENEW.PROCESS.COMMON
    $INSERT I_F.LATAM.CARD.ORDER
    $INSERT I_F.REDO.CARD.REQUEST
*    $INSERT I_BATCH.FILES ;*R22 Manual Conversion
    $INSERT I_F.COMPANY
    $INSERT I_GTS.COMMON
    $INSERT I_F.CARD.TYPE
    $INSERT I_F.DATES
    $USING EB.Service
*   $INSERT I_F.COMPANY ;* R22 Auto conversion
    $INSERT I_F.REDO.CARD.RENEWAL

*PACS00063156-S

*    SEL.LCO.ID = ''
*   SEL.CMD.COMP = "SELECT ":FN.COMPANY
*   CALL EB.READLIST(SEL.CMD.COMP,SEL.LIST.COMP,'',NO.REC,PGM.ERR)

*   LOOP
*       REMOVE Y.COMP.ID FROM SEL.LIST.COMP SETTING COMP.POS
*   WHILE Y.COMP.ID:COMP.POS

*       CALL F.READ(FN.COMPANY,Y.COMP.ID,R.COMP,F.COMPANY,Y.ERR.COMP)
*       Y.FIN.COMP = R.COMP<EB.COM.FINANCIAL.COM>
*       SEL.LIST.LCO = ''
*       SEL.CMD.LCO = ''

    FETCH.LWD = R.DATES(EB.DAT.LAST.WORKING.DAY)
    FETCH.NWD = R.DATES(EB.DAT.TODAY)

    SEL.CMD.LCO = "SELECT ":FN.LATAM.CARD.ORDER:" WITH CARD.STATUS EQ 94 AND WITH EMBOSS.TYPE EQ PERSONALIZADA AND WITH ( RENEWAL.DATE GT ": FETCH.LWD :" AND WITH RENEWAL.DATE LE " :FETCH.NWD : ")"

    CALL EB.READLIST(SEL.CMD.LCO,SEL.LIST.LCO,'',NO.REC.LCO,PGM.ERR.LCO)


*IF SEL.LIST.LCO EQ '' THEN
*           CONTINUE
*      END
*     CHANGE FM TO '*' IN SEL.LIST.LCO
*    IF SEL.LCO.ID EQ '' THEN
*        SEL.LCO.ID = SEL.LIST.LCO
*    END ELSE
*        SEL.LCO.ID<-1> = SEL.LIST.LCO
*    END
* REPEAT

*    CALL BATCH.BUILD.LIST('',SEL.LIST.LCO)
    EB.Service.BatchBuildList('',SEL.LIST.LCO);* R22 UTILITY AUTO CONVERSION
 
*PACS00063156-E
RETURN
END
