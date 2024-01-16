* @ValidationCode : MjotMTMyOTk1MjA1NDpDcDEyNTI6MTcwMzIwMjI1OTAzNTp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 22 Dec 2023 05:14:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.AA ;*Manual R22 Code Conversion
PROGRAM AA.REMOVE.DATED.IVR 

*-----------------------------------------------------------------------------------

*Modification History:
*
* Date                     Who                        Reference                                        Description
* ----                    ----                                ----                                        ----
* 29-March-2023          Ajith Kumar              Manual R22 Code Conversion                Package Name added APAP.AA

* 29-March-2023          Conversion Tool                         R22 Auto Code Conversion                              No Change
*21-12-2023        VIGNESHWARI      MANUAL R22 CODE CONVERSION      CALL RTN MODIFIED, CHANGED F.READ TO F.READU
*-----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING EB.TransactionControl

    FN.AA.PRODUCT.CATALOG = 'F.AA.PRODUCT.CATALOG'
    F.AA.PRODUCT.CATALOG = ''
    CALL OPF(FN.AA.PRODUCT.CATALOG,F.AA.PRODUCT.CATALOG)

    FN.AA.PRODUCT.CATALOG.DATED.XREF = 'F.AA.PRODUCT.CATALOG.DATED.XREF'
    F.AA.PRODUCT.CATALOG.DATED.XREF = ''
    CALL OPF(FN.AA.PRODUCT.CATALOG.DATED.XREF,F.AA.PRODUCT.CATALOG.DATED.XREF)

    FN.AA.PRODUCT.DESIGNER = 'F.AA.PRODUCT.DESIGNER'
    F.AA.PRODUCT.DESIGNER = ''
    CALL OPF(FN.AA.PRODUCT.DESIGNER,F.AA.PRODUCT.DESIGNER)

    FN.AA.PRODUCT.DESIGNER.DATED.XREF = 'F.AA.PRODUCT.DESIGNER.DATED.XREF'
    F.AA.PRODUCT.DESIGNER.DATED.XREF = ''
    CALL OPF(FN.AA.PRODUCT.DESIGNER.DATED.XREF,F.AA.PRODUCT.DESIGNER.DATED.XREF)



    Y.ID = 'PERSONAL.TEL-20120612'
    CALL F.DELETE(FN.AA.PRODUCT.CATALOG,Y.ID)
   * CALL JOURNAL.UPDATE('')
   EB.TransactionControl.JournalUpdate('') ;*R22 MANUAL CONVERSION-CALL RTN MODIFIED
    CRT "AA.PRODUCT.CATALOG MODIFIED"

    Y.ID = 'PERSONAL.TEL'
*CALL F.READ(FN.AA.PRODUCT.CATALOG.DATED.XREF,Y.ID,R.PRD.CAT,F.AA.PRODUCT.CATALOG.DATED.XREF,PRD.ERR)
    CALL F.READU(FN.AA.PRODUCT.CATALOG.DATED.XREF,Y.ID,R.PRD.CAT,F.AA.PRODUCT.CATALOG.DATED.XREF,PRD.ERR,"") ;*R22 MANUAL CONVERSION-CHANGE F.READ TO F.READU
    R.PRD.CAT = '20090101'
    CALL F.WRITE(FN.AA.PRODUCT.CATALOG.DATED.XREF,Y.ID,R.PRD.CAT)
    CALL JOURNAL.UPDATE('')
    CRT "AA.PRODUCT.CATALOG.DATED.REF MODIFIED "

    Y.ID = 'PERSONAL.TEL-20120612'
    CALL F.DELETE(FN.AA.PRODUCT.DESIGNER,Y.ID)
   * CALL JOURNAL.UPDATE('')
   EB.TransactionControl.JournalUpdate('') ;*R22 MANUAL CONVERSION-CALL RTN MODIFIED
    CRT "AA.PRODUCT.DESIGNER MODIFIED"

    Y.ID = 'PERSONAL.TEL'
   * CALL F.READ(FN.AA.PRODUCT.DESIGNER.DATED.XREF,Y.ID,R.PRD.SN,F.AA.PRODUCT.DESIGNER.DATED.XREF,ERRR)
   CALL F.READU(FN.AA.PRODUCT.DESIGNER.DATED.XREF,Y.ID,R.PRD.SN,F.AA.PRODUCT.DESIGNER.DATED.XREF,ERRR,"");*R22 MANUAL CONVERSION-CHANGE F.READ TO F.READU
    R.PRD.SN = '20090101'
    CALL F.WRITE(FN.AA.PRODUCT.DESIGNER.DATED.XREF,Y.ID,R.PRD.SN)
   * CALL JOURNAL.UPDATE('')
   EB.TransactionControl.JournalUpdate('') ;*R22 MANUAL CONVERSION-CALL RTN MODIFIED
    CRT "AA.PRODUCT.DESIGNER.DATED.XREF MODIFIED"

RETURN

END
