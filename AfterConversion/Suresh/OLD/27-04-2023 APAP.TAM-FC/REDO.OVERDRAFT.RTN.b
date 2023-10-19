* @ValidationCode : MjoxOTc1NTIwNjE4OkNwMTI1MjoxNjgwODg4MzAxNTcwOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 07 Apr 2023 22:55:01
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.OVERDRAFT.RTN
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.OVERDRAFT.RTN
*--------------------------------------------------------------------------------------------------------
*Description       : This is a CONVERSION routine attached to an enquiry, the routine fetches the
*                    from account and limit application and returns it to O.DATA
*Linked With       : Enquiry ENQ.REDO.OVERDRAFT.ACCOUNT
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date           Who               Reference                                 Description
*     ------         -----             -------------                             -------------
* 16 NOV 2010       NATCHIMUTHU.P        ODR-2010-03-0089                         Initial Creation
* 10.04.2023       Conversion Tool       R22                                  Auto Conversion     - F TO CACHE
* 10.04.2023       Shanmugapriya M       R22                                  Manual Conversion   - No changes
*
*********************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT.OVERDRAWN


    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)


    FN.ACCOUNT.OVERDRAWN = 'F.ACCOUNT.OVERDRAWN'
    F.ACCOUNT.OVERDRAWN  = ''
    CALL OPF(FN.ACCOUNT.OVERDRAWN,F.ACCOUNT.OVERDRAWN)

    ACCOUNT.ID = O.DATA

    CALL CACHE.READ(FN.ACCOUNT.OVERDRAWN, ACCOUNT.ID, R.ACCOUNT.OVERDRAWN, Y.ERR)        ;** R22 Auto conversion - F TO CACHE
    IF R.ACCOUNT.OVERDRAWN THEN
        Y.DATE.FIRST.OD  =  R.ACCOUNT.OVERDRAWN<AC.OD.DATE.FIRST.OD>
        Y.TODAY          = TODAY
        NO.OF.DAYS = 'C'
        CALL CDD('',Y.DATE.FIRST.OD,Y.TODAY,NO.OF.DAYS)
        O.DATA = NO.OF.DAYS
    END ELSE
        O.DATA = ''
    END
RETURN
END
*-----------------------------------------------------------------------------------------------------------------------------
* PROGRAM END
*------------------------------------------------------------------------------------------------------------------------------
