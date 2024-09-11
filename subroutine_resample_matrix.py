import numpy as np

def resample_matrix(A,N_resample):
    """
    Generate N_B new matrices from the original matrix A.
    Each new matrix A_i is created by selecting rows and columns from A using a random index 'idx'.

    Args:
    A (np.ndarray): The original matrix.
    N_resample (int): The number of matrices to generate.

    Returns:
    List[np.ndarray]: A list of generated matrices.
    """

    n = A.shape[0]
    generated_matrices = []

    for _ in range(N_resample):
        idx = np.random.choice(n, n, replace=True)
        A_i = A[np.ix_(idx, idx)]
        generated_matrices.append(A_i)

    return generated_matrices

        