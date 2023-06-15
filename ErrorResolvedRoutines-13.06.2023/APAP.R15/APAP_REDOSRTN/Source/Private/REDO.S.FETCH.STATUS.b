* @ValidationCode : Mjo5MDk5MTIwNjE6Q3AxMjUyOjE2ODU5NTEyMzM2NjI6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Jun 2023 13:17:13
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOSRTN
*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.S.FETCH.STATUS
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is attached with  EB.GC.CONSTRAINTS records for AZ.ACCOUNT and ACCOUNT
*It will generate error message when AZ.ACCOUNT OR ACCOUNT is created for 'DECEASED' OR
*CLOSED customer
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 27-DEC-2009        Prabhu.N       ODR-2009-10-0535     Initial Creation
* 18.05.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 18.05.2023       Shanmugapriya M       R22            Manual Conversion   - ASSIGN TO ASSIGNED
*
*------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.ID.CARD.CHECK
    $INSERT I_F.AZ.ACCOUNT

    GOSUB INIT
    GOSUB PRE.CHECK
    GOSUB ASSIGNED                 ;* R22 Manual conversion
RETURN
*----
INIT:
*----

    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
RETURN

*---------
PRE.CHECK:
*---------
    Y.IDENTITY.TYPE = R.NEW(REDO.CUS.PRF.IDENTITY.TYPE)

    BEGIN CASE
        CASE Y.IDENTITY.TYPE EQ "RNC"
            FN.RNC = "F.CUSTOMER.L.CU.RNC"
            F.RNC = ''
            CALL OPF(FN.RNC,F.RNC)
            R.RNC = ''
            CALL F.READ(FN.RNC,COMI,R.RNC,F.RNC,E.RNC)
            IF NOT(E.RNC) THEN
                COMI = FIELD(R.RNC,"*",2)
            END
        CASE Y.IDENTITY.TYPE EQ "CEDULA"

        CASE Y.IDENTITY.TYPE EQ "PASAPORTE"

    END CASE

RETURN

*------
ASSIGNED:                 ;* R22 Manual conversion
*------

    CALL F.READ(FN.CUSTOMER,COMI,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    COMI = R.CUSTOMER<EB.CUS.CUSTOMER.STATUS>
*FIX-PACS00538272-S
    IF PGM.VERSION EQ ',OFS' AND COMI EQ '3' AND R.NEW(AZ.FREQUENCY) NE R.OLD(AZ.FREQUENCY) THEN
        COMI = ''
    END
*FIX-PACS00538272-E
    IF PGM.VERSION EQ ',REDO.AZ.UPDATE' AND COMI EQ '3' AND R.NEW(AZ.ROLLOVER.INT.RATE) NE R.OLD(AZ.ROLLOVER.INT.RATE) THEN
        COMI = ''
    END
RETURN
END
