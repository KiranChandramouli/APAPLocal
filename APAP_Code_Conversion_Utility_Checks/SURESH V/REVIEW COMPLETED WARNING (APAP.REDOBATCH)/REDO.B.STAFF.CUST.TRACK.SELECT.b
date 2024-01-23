* @ValidationCode : MjotMTI4OTU2MDg4ODpDcDEyNTI6MTcwNDQ0MDUyNjc3NzozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Jan 2024 13:12:06
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
SUBROUTINE REDO.B.STAFF.CUST.TRACK.SELECT

****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : RAJA SAKTHIVEL K P
* Program Name  : REDO.B.STAFF.CUST.TRACK.SELECT
*-------------------------------------------------------------------------
* Description: This routine is a select routine to load all the necessary variables for the
* multi threaded process
*----------------------------------------------------------
* Linked with: Multi threaded batch routine REDO.B.STAFF.CUST.TRACK
* In parameter : None
* out parameter : CUST.ID
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 03-03-10      ODR-2009-10-0532                     Initial Creation
* 07-12-11      ODR-2009-10-0532                    Cob Pefromance Select has been changed and loop part is removed
* 13-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 13-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*18/01/2024         Suresh                  R22 UTILITY AUTO CONVERSION  CALL routine Modified
*------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_REDO.B.STAFF.CUST.TRACK.COMMON
    $INSERT I_F.REDO.EMPLOYEE.ACCOUNTS
    $USING EB.Service

    GOSUB INITIALISE
    GOSUB PROCESS

RETURN


*-------------
INITIALISE:
*---------------------------------
* variables are initialised here
*---------------------------------
    Y.CUST.ID = ''
    Y.HIS.ID = ''

RETURN
*----------
PROCESS:
*------------------------------------------------
* The main selection process is carried on here
*------------------------------------------------

*    SEL.CMD = "SELECT ":FN.CUSTOMER
    SEL.CMD = "SELECT ":FN.REDO.W.CUSTOMER.UPDATE
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECORDS,RET.CODE)
*    CALL BATCH.BUILD.LIST('',SEL.LIST)
    EB.Service.BatchBuildList('',SEL.LIST);* R22 UTILITY AUTO CONVERSION
*    LOOP
*       REMOVE Y.CUST.ID FROM SEL.LIST SETTING POS
*  WHILE Y.CUST.ID:POS
*     CALL F.READ(FN.CUSTOMER,Y.CUST.ID,R.CUSTOMER,F.CUSTOMER,ERR.CUSTOMER)
*    Y.CURR.NO = R.CUSTOMER<EB.CUS.CURR.NO>
*   Y.HIS.ID = Y.CUST.ID:';':Y.CURR.NO
*  CALL EB.READ.HISTORY.REC(F.SEC.ACC.MASTER.$HIS,Y.HIS.ID,R.HIS.ID,ERR.HIS.ID)
* GOSUB CHECK.VALUE
*    REPEAT
*    CALL BATCH.BUILD.LIST('',CUST.ID)
*   RETURN

*---------------
CHECK.VALUE:
*------------------------------------
* Getting fax value from live record
*------------------------------------

*   CALL F.READ(FN.CUSTOMER,Y.CUST.ID,R.CUSTOMER,F.CUSTOMER,ERR.CUSTOMER)


*    Y.FAX.LIVE = R.CUSTOMER<EB.CUS.FAX.1>

*   Y.FAX.HIS = R.HIS.ID<EB.CUS.FAX.1>

*  IF Y.FAX.HIS EQ '' AND Y.FAX.LIVE NE '' THEN
*     CUST.ID<-1> = Y.CUST.ID
* END

RETURN

*------------------------------------------------------------
END
