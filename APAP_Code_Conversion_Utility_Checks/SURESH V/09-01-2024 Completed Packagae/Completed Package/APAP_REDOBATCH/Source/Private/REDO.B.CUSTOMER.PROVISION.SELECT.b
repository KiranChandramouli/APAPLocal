* @ValidationCode : MjotMjAyNDY4MDI0OTpDcDEyNTI6MTcwMzU3NjEwMTczOTozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 Dec 2023 13:05:01
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
SUBROUTINE REDO.B.CUSTOMER.PROVISION.SELECT
******************************************************************************
*  Company   Name    : Asociacion Popular de Ahorros y Prestamos
*  Developed By      : G.Bharath
*  ODR Number        : ODR-2009-11-0159
*  Program   Name    : REDO.B.CUSTOMER.PROVISION.SELECT.
*-----------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : --N/A--
*-----------------------------------------------------------------------------
* DESCRIPTION       : This Multi-thread BATCH routine is to calculate CUSTOMER provision
*                     values based on the arrangements with the CUSTOMER during COB
*------------------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE            WHO           REFERENCE                    DESCRIPTION
*  -----           ----          ----------                  -----------
*  22-Oct-2010     G.Bharath      ODR-2009-11-0159            INITIAL CREATION
* 07-JULY-2011     JEEVA T        PACS00064596                changes in claculating overdue days
* 04-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_F.REDO.H.CUSTOMER.PROVISIONING
    $INSERT I_F.REDO.H.PROVISION.PARAMETER
    $INSERT I_REDO.B.CUSTOMER.PROVISION.COMMON
    
    $USING EB.Service ;*R22 Manual Conversion
*****************************************************************************
*
    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
*****************************************************************************
INITIALISE:
*----------------------------------------------------------------------------
*
    SEL.CMD.CUS  = ''
    SEL.LIST.CUS = ''

RETURN
*----------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------
*

    IF Y.NEXT.RUN.DATE LE TODAY THEN
*        SEL.CMD.CUS = 'SELECT ':FN.CUSTOMER.ACCOUNT
        SEL.CMD.CUS = 'SELECT ':FN.REDO.CUSTOMER.ARRANGEMENT
        CALL EB.READLIST(SEL.CMD.CUS,SEL.LIST.CUS,'',NO.OF.REC,SEL.ERR)
    END

*    CALL BATCH.BUILD.LIST('',SEL.LIST.CUS)
    EB.Service.BatchBuildList('',SEL.LIST.CUS) ;*R22 Manual Conversion

RETURN
*----------------------------------------------------------------------------
END
