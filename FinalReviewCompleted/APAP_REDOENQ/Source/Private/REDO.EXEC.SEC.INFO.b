* @ValidationCode : MjotOTc0ODE3MzM4OkNwMTI1MjoxNjgyMDc4ODcyNDM3OklUU1M6LTE6LTE6Mjg0OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Apr 2023 17:37:52
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 284
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.EXEC.SEC.INFO(CUST.ID,OTH.OFFICER)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This development is for ODR Reference ODR-2010-04-0425
* This subroutine is to check the relation code and return second multivalue
* field as OTH.OFFICER
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : @ID
* CALLED BY : OTH.OFFICER
*
* Revision History:
*------------------------------------------------------------------------------------------
* Date               who             Reference            Description
* 25-Nov-2009        B Renugadevi    ODR-2010-04-0425     Initial Creation
* 17-Jul-2011        S Sudharsanan   PACS00084100           Mdoify the code as discussion with pamela
*
* 18-APR-2023     Conversion tool    R22 Auto conversion     F.READ to CACHE.READ
* 18-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.DEPT.ACCT.OFFICER

    GOSUB INIT
    GOSUB PROCESS
RETURN
*****
INIT:
*****

    CUS.ID       = CUST.ID
    FN.CUSTOMER  = 'F.CUSTOMER'
    F.CUSTOMER   = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    FN.DAO = 'F.DEPT.ACCT.OFFICER'
    F.DAO = ''
    CALL OPF(FN.DAO,F.DAO)
    OTH.OFFICER = ''
RETURN
********
PROCESS:
********
    CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    IF R.CUSTOMER<EB.CUS.OTHER.OFFICER,1> NE '' THEN
        OTH.OFFICER.ID = R.CUSTOMER<EB.CUS.OTHER.OFFICER,1>
        CALL CACHE.READ(FN.DAO, OTH.OFFICER.ID, R.DAO, DAO.ERR) ;*R22 Auto conversion

        OTH.OFFICER = R.DAO<EB.DAO.NAME>
    END ELSE
        OTH.OFFICER.ID = ''
    END
RETURN
END
*-----------------------------------------------------------------------------------------
