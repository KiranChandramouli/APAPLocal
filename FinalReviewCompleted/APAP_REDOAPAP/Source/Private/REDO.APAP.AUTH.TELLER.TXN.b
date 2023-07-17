* @ValidationCode : MjoxODM0MTI1Njg0OkNwMTI1MjoxNjg0ODM2MDMzMjU3OklUU1M6LTE6LTE6NDg0OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 484
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.AUTH.TELLER.TXN
********************************************************************************
******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :DHAMU S
*  Program   Name    :REDO.APAP.AUTH.TELLER.TXN
***********************************************************************************
*Description:    This is an AUTHORISATION routine attached to the Enquiry used
*                to authorise the teller transaction when the user clicks the authorise button
*****************************************************************************
*linked with:
*In parameter:
*Out parameter:
**********************************************************************
* Modification History :
***********************************************************************
*DATE                WHO                   REFERENCE         DESCRIPTION
*25-MAY-2011       DHAMU.S               PACS00061652       INITIAL CREATION
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*11-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*11-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

****************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER
    $INSERT I_F.TELLER.ID
    $INSERT I_F.TELLER

    GOSUB OPEN
    GOSUB PROCESS
RETURN

*****
OPEN:
*****

    FN.TELLER = 'F.TELLER'
    F.TELLER  = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.USER = 'F.USER'
    F.USER  = ''
    CALL OPF(FN.USER,F.USER)

    FN.TELLER.ID = 'F.TELLER.ID'
    F.TELLER.ID  = ''
    CALL OPF(FN.TELLER.ID,F.TELLER.ID)

RETURN

********
PROCESS:
********
    Y.RECORD.STATUS  = R.NEW(TT.TE.RECORD.STATUS)
    IF Y.RECORD.STATUS EQ 'INAU' THEN
        Y.USER = OPERATOR
        Y.TELLER.ID.1 = R.NEW(TT.TE.TELLER.ID.1)
        CALL F.READ(FN.TELLER.ID,Y.TELLER.ID.1,R.TELLER.ID,F.TELLER.ID,TT.ERR)
        TT.USR1  = R.TELLER.ID<TT.TID.USER>
        Y.TELLER.ID.2 = R.NEW(TT.TE.TELLER.ID.2)
        CALL F.READ(FN.TELLER.ID,Y.TELLER.ID.2,R.TELLER.ID,F.TELLER.ID,TT.ERR1)
        TT.USR2  = R.TELLER.ID<TT.TID.USER>
        IF TT.USR1 EQ Y.USER OR TT.USR2 EQ Y.USER ELSE
            AF    = TT.TE.TELLER.ID.1
            E     = 'EB-TELLER.NOT.AUTH'
        END
    END
RETURN
********************************************************
END
*----------------End of Program-----------------------------------------------------------
