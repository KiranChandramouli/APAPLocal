* @ValidationCode : MjotMTU2NTQyODk0MjpDcDEyNTI6MTcwNDg4ODI1NTU2NjozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Jan 2024 17:34:15
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
SUBROUTINE REDO.RELCUS.EDU.LVL(CUST.ID,EDU.LVEL)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This is field format routine for pdf generation form of KYC
* Input/Output:
*--------------
* IN :CUSTOMER.ID
* OUT : EDUCATION.LEVEL
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
* Revision History:
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*13/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION          VM TO @VM,++ TO +=
*13/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*------------------------------------------------------------------------------------------
* Date who Reference Description
* 25-Nov-2009 B Renugadevi ODR-2010-04-0425 Initial Creation
* 19-Jul-2011 S Sudharsanan PACS00084100 Modify as per issue
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.BRAN.EDU.DETS
    $INSERT I_F.USER
    $USING EB.LocalReferences
    GOSUB INIT
    GOSUB PROCESS
RETURN

******
INIT:
******
    EDU.LVEL = ''
    VAR.USE.LANG = R.USER<EB.CUS.LANGUAGE>
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

*    CALL GET.LOC.REF('CUSTOMER','L.CU.EDU.LEVEL',EDU.LEVEL.POS)
    EB.LocalReferences.GetLocRef('CUSTOMER','L.CU.EDU.LEVEL',EDU.LEVEL.POS);* R22 UTILITY AUTO CONVERSION

    FN.BRAN.EDU = 'F.REDO.BRAN.EDU.DETS'
    F.BRAN.EDU = ''
    CALL OPF(FN.BRAN.EDU,F.BRAN.EDU)

RETURN
********
PROCESS:
********
    START.UP.COUNT = 1
    CALL F.READ(FN.CUSTOMER,CUST.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    IF R.CUSTOMER THEN
        EDU.LVL = R.CUSTOMER<EB.CUS.LOCAL.REF,EDU.LEVEL.POS>
    END
    ID.CNT = DCOUNT(EDU.LVL,@VM)
    LOOP
    WHILE START.UP.COUNT LE ID.CNT
        EDU.ID = EDU.LVL<1,START.UP.COUNT>
        CALL F.READ(FN.BRAN.EDU,EDU.ID,R.EDU.LVL,F.BRAN.EDU,BRAN.EDU.ERR)
        LEV.DESC = R.EDU.LVL<CUS.DESCRIPTION,VAR.USE.LANG>
        IF NOT(LEV.DESC) THEN
            LEV.DESC = R.EDU.LVL<CUS.DESCRIPTION,1>
        END
        EDU.LVEL<1,-1> = LEV.DESC
        START.UP.COUNT += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT
RETURN
END
